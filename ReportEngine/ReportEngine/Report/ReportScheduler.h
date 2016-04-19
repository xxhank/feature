//
// ReportScheduler.h
// ReportEngine
//
// Created by wangchaojs02 on 16/4/19.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Schedule)();
@protocol ReportScheduler <NSObject>
- (void)start;
- (void)stop;
- (void)setSchedule:(Schedule)schedule;
@end
