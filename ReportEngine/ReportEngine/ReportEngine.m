//
// ReportEngine.m
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import "ReportEngine.h"

#define RELog(fmt, ...) NSLog(@"<%s:%d %s>" fmt, strrchr(__FILE__, '/') + 1, __LINE__, __FUNCTION__,##__VA_ARGS__)
@interface ReportEngine ()
@property (nonatomic, weak) NSThread *checkThread;
@property (nonatomic, weak) NSTimer  *timer;
@end

@implementation ReportEngine
- (void)start
{
    if (self.checkThread)
    {
        RELog("already runing");
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
        RELog("thread not exist");
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

    [self.timer invalidate];
} /* stop */

#pragma mark - thread
- (void)threadMain:(id)session
{
    RELog(@"");
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(check)
                                                    userInfo:nil
                                                     repeats:YES];

    self.timer = timer;

    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    while (timer.valid)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }


    RELog(@"");
} /* threadMain */

- (void)check
{
    RELog(@"%@", [NSThread currentThread]);
}

@end
