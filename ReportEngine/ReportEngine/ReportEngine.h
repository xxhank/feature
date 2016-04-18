//
// ReportEngine.h
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportManager.h"
#import "ReportFetcher.h"
#import "ReportSchedule.h"

@interface ReportEngine : NSObject

- (instancetype)initWithManager:(ReportManager*)manager
                        fetcher:(ReportFetcher*)fetcher
                       schedule:(ReportSchedule*)schedule NS_DESIGNATED_INITIALIZER;
- (void)start;
- (void)stop;
- (void)traceItem:(ReportItem*)item;
@end
