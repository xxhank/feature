//
// ReportEngine.h
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportQueue.h"
#import "ReportFetcher.h"
#import "ReportScheduler.h"

@class ReportItem;

@interface ReportEngine : NSObject
@property (nonatomic, assign, readonly) NSInteger success;
@property (nonatomic, assign, readonly) NSInteger failed;
@property (nonatomic, assign, readonly) NSInteger pending;

- (instancetype)initWithScheduler:(id<ReportScheduler>)scheduler
                          fetcher:(id<ReportFetcher>)fetcher
                            queue:(id<ReportQueue>)queue NS_DESIGNATED_INITIALIZER;
- (void)start;
- (void)stop;
- (void)traceItem:(ReportItem*)item;
@end
