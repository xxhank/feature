//
// ReportItem.m
// ReportEngine
//
// Created by wangchaojs02 on 16/4/19.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import "ReportItem.h"

@implementation ReportItem
- (instancetype)init
{
    self = [super init];

    if (self)
    {
        _timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    }
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ %zd",
            [NSDate dateWithTimeIntervalSince1970:self.timestamp / 1000.0],
            self.retryTimes];
}

@end

@implementation  ReportItem (SavePresent)
- (instancetype)initWithSavePresent:(id)savePresent
{
    self = [super init];

    if (self)
    {
        _timestamp  = [[savePresent valueForKey:@"timestamp"] doubleValue];
        _retryTimes = [[savePresent valueForKey:@"retry"] integerValue];
    }
    return self;
}

- (id)savePresent
{
    return @{@"timestamp":@(self.timestamp)
             , @"retry":@(self.retryTimes)};
}

@end
