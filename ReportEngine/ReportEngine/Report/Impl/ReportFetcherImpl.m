//
// ReportFetcher.m
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import "ReportFetcherImpl.h"

@interface ReportFetcherImpl ()
@property (atomic, assign) BOOL canceled;
@end
@implementation ReportFetcherImpl
- (void)report:(ReportItem*)item completion:(ReportCompletion)comletion
{
    NSTimeInterval delay   = arc4random() % 2000 / 1000.0;
    BOOL           success = arc4random() % 5 == 0;

    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW, (int64_t) (delay * NSEC_PER_SEC) ), dispatch_get_main_queue(), ^{
        if(wself.canceled)
        {
            return;
        }

        if(success)
        {
            comletion(@(YES), nil);
        }
        else
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:@"failed"};
            NSError *error = [NSError errorWithDomain:@"ReportFetcher"
                                                 code:-1
                                             userInfo:userInfo];
            comletion(nil, error);
        }
    });
} /* report */

- (void)cancel
{
    self.canceled = YES;
}

@end
