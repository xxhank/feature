//
// ReportScheduler.m
// ReportEngine
//
// Created by wangchaojs02 on 16/4/19.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import "ReportSchedulerImpl.h"
#import "SSLogger.h"

@interface ReportSchedulerImpl ()
@property (nonatomic, copy) Schedule  schedule;
@property (nonatomic, weak) NSThread *checkThread;
@property (nonatomic, weak) NSTimer  *checkTimer;
@end

@implementation ReportSchedulerImpl

- (void)start
{
    if (self.checkThread)
    {
        SSLogInfo("already runing");
        return;
    }
    NSThread *thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(threadMain:)
                                                 object:nil];

    self.checkThread      = thread;
    self.checkThread.name = @"check thread";
    [self.checkThread start];
} /* start */

- (void)stop
{
    if(!self.checkThread)
    {
        SSLogInfo("thread not exist");
        return;
    }

    if ([NSThread currentThread] != self.checkThread)
    {
        [self performSelector:@selector(stop)
                     onThread:self.checkThread
                   withObject:nil
                waitUntilDone:false];
        return;
    }

    [self.checkTimer invalidate];
} /* stop */

#pragma mark - thread
- (void)threadMain:(id)session
{
    SSLogInfo(@"Begin");
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(check)
                                                    userInfo:nil
                                                     repeats:YES];
    
    self.checkTimer = timer;
    NSString *mode = NSDefaultRunLoopMode;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:mode];

    while (timer.valid)
    {
        [[NSRunLoop currentRunLoop] runMode:mode beforeDate:
         [NSDate distantFuture]];
         //[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }


    SSLogInfo(@"Done");
} /* threadMain */

- (void)check
{
    if (self.schedule)
    {
        self.schedule();
    }
}

@end
