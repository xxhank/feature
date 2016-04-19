//
// ReportEngine.m
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import "ReportEngine.h"
#import "SSLogger.h"
#import "ReportQueueImpl.h"
#import "ReportFetcherImpl.h"
#import "ReportSchedulerImpl.h"
#import "ReportItem.h"

const NSInteger MaxRetryTimes = 3;

@interface ReportEngine ()
@property (nonatomic, strong) id<ReportScheduler> scheduler;
@property (nonatomic, strong) id<ReportFetcher>   fetcher;
@property (nonatomic, strong) id<ReportQueue >    queue;
@property (nonatomic, assign) BOOL                reporting;

@property (nonatomic, assign) NSInteger success;
@property (nonatomic, assign) NSInteger failed;
@end

@implementation ReportEngine
- (instancetype)init
{
    return [self initWithScheduler:[[ReportSchedulerImpl alloc] init]
                           fetcher:[[ReportFetcherImpl alloc] init]
                             queue:[[ReportQueueImpl alloc] init]];
}

- (instancetype)initWithScheduler:(id<ReportScheduler>)scheduler
                          fetcher:(id<ReportFetcher>)fetcher
                            queue:(id<ReportQueue>)queue
{
    if (self = [super init])
    {
        _queue     = queue;
        _fetcher   = fetcher;
        _scheduler = scheduler;

        __weak typeof(self) wself = self;
        [_scheduler setSchedule:^{
            [wself check];
        }];
    }

    return self;
} /* initWithManager */

- (void)start
{
    [self.scheduler start];
}

- (void)stop
{
    [self.fetcher cancel];
    [self.scheduler stop];
    [self.queue save];
}

- (void)traceItem:(ReportItem*)item
{
    [self.queue enqueue:item];
}

- (NSInteger)pending
{
    return [self.queue size];
}

#pragma mark -
- (void)check
{
    ReportItem *item = [self.queue dequeue];

    if (!item)
    {
        SSLogInfo(@"nothing need report");
        return;
    }

    if (self.reporting)
    {
        return;
    }
    self.reporting = YES;
    SSLogInfo("report :%@", item);
    __weak typeof(self) wself = self;
    [self.fetcher report:item completion:^(id result, NSError *error) {
        if (error)
        {
            if(item.retryTimes++ < MaxRetryTimes)
            {
                [wself.queue enqueue:item];
            }
            else
            {
                wself.failed++;
                SSLogError("retry too many times, discard it. %zd", item.retryTimes);
            }
        }
        else
        {
            wself.success++;
        }

        wself.reporting = NO;
        SSLogInfo("report :%@ %@", item, error ? : @"sucess");
    }];
} /* check */

@end
