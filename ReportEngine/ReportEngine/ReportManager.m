//
// ReportDataManager.m
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import "ReportManager.h"
#import "SSLogger.h"

const NSInteger MaxRetryTimes = 3;
@interface ReportItem ()
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, assign) NSInteger      retryTimes;
@end

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

@interface ReportManager ()
@property (nonatomic, strong) NSMutableArray<ReportItem*> *items;
@end

@implementation ReportManager

- (void)traceItem:(ReportItem*)item
{
    @synchronized (self)
    {
        SSLogInfo(@"%zd", self.items.count);
        [self.items addObject:item];
    }
}

- (ReportItem*)item
{
    ReportItem *temp = nil;

    @synchronized (self)
    {
        temp = self.items.firstObject;
    }
    return temp;
}

- (void)processFailedItem:(ReportItem*)item
{
    @synchronized (self)
    {
        if (item.retryTimes < MaxRetryTimes)
        {
            [self.items addObject:item];
        }
    }
}

- (void)processSuccessItem:(ReportItem*)item
{
    @synchronized (self)
    {
        [self.items removeObject:item];
    }
}

- (NSMutableArray<ReportItem*>*)items
{
    if (!_items)
    {
        _items = [NSMutableArray arrayWithCapacity:10];
    }
    return _items;
}

@end
