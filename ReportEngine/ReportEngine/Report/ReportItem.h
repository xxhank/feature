//
// ReportItem.h
// ReportEngine
//
// Created by wangchaojs02 on 16/4/19.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportItem : NSObject
@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, assign) NSInteger      retryTimes;

@end

@interface ReportItem (SavePresent)
- (instancetype)initWithSavePresent:(id)savePresent;
- (id)savePresent;
@end
