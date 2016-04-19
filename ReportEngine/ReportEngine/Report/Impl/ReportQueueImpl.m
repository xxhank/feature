//
// ReportDataManager.m
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import "ReportQueueImpl.h"
#import "SSLogger.h"
#import "ReportItem.h"
#import "SSStorage.h"

#pragma ReportQueueConstants
static NSString*const SSReportQueueKey = @"report-queue";

@interface ReportQueueImpl ()
@property (nonatomic, strong) NSMutableArray<ReportItem*> *items;
@end

@implementation ReportQueueImpl
- (instancetype)init
{
    self = [super init];

    if (self)
    {
        [self load];
    }
    return self;
}

#pragma mark -
- (void)enqueue:(ReportItem*)item
{
    @synchronized (self)
    {
        [self.items addObject:item];
    }
}

- (ReportItem*)dequeue
{
    ReportItem *temp = nil;

    @synchronized (self)
    {
        if(self.items.count > 1)
        {
            temp = self.items.firstObject;
            [self.items removeObjectAtIndex:0];
        }
    }
    return temp;
} /* dequeue */

- (NSUInteger)size
{
    @synchronized (self)
    {
        return self.items.count;
    }
}

- (void)load
{
    NSArray *savePresents = [[SSStorage defaults] arrayForKey:SSReportQueueKey];

    _items = [NSMutableArray arrayWithCapacity:savePresents.count];

    for (id savePresent in savePresents)
    {
        [_items addObject:[[ReportItem alloc] initWithSavePresent:savePresent]];
    }
}

- (void)save
{
    @synchronized (self)
    {
        NSMutableArray *presentArray = [NSMutableArray arrayWithCapacity:self.items.count ];

        for (ReportItem *item in self.items)
        {
            [presentArray addObject:[item savePresent]];
        }
        [[SSStorage defaults] setObject:presentArray forKey:SSReportQueueKey];
    }
} /* save */

#pragma mark - property
- (NSMutableArray<ReportItem*>*)items
{
    if (!_items)
    {
        _items = [NSMutableArray arrayWithCapacity:10];
    }
    return _items;
}

@end
