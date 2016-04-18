//
// ReportSchedule.h
// ReportEngine
//
// Created by wangchaojs02 on 16/4/19.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Schedule)();
@interface ReportSchedule : NSObject
@property (nonatomic, copy) Schedule schedule;
- (void)start;
- (void)stop;
@end
