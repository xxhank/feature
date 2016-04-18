//
// ReportEngine.m
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import "ReportEngine.h"
#import "SSLogger.h"

@interface ReportEngine ()
@property (nonatomic, strong) ReportSchedule *schedule;
@property (nonatomic, strong) ReportManager  *manager;
@property (nonatomic, strong) ReportFetcher  *fetcher;
@property (nonatomic, assign) BOOL            reporting;
@end

@implementation ReportEngine
- (instancetype)init
{
    return [self initWithManager:[[ReportManager alloc] init]
                         fetcher:[[ReportFetcher alloc] init]
                        schedule:[[ReportSchedule alloc] init]];
}

- (instancetype)initWithManager:(ReportManager*)manager
                        fetcher:(ReportFetcher*)fetcher
                       schedule:(ReportSchedule*)schedule
{
    if (self = [super init])
    {
        _manager  = manager;
        _fetcher  = fetcher;
        _schedule = schedule;

        __weak typeof(self) wself = self;

        _schedule.schedule = ^{
            [wself check];
        };
    }

    return self;
} /* initWithManager */

- (void)start
{
    [self.schedule start];
}

- (void)stop
{
    [self.schedule stop];
}

- (void)traceItem:(ReportItem*)item
{
    [self.manager traceItem:item];
}

#pragma mark -
- (void)check
{
    ReportItem *item = [self.manager item];

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
            [wself.manager processFailedItem:item];
        }
        else
        {
            [wself.manager processSuccessItem:item];
        }
        wself.reporting = NO;
        SSLogInfo("report :%@ %@", item, error ? : @"sucess");
    }];
} /* check */

@end
