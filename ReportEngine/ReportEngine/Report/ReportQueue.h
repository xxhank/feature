//
// ReportDataManager.h
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ReportItem;

@protocol ReportQueue <NSObject>
- (ReportItem*)dequeue;
- (void)enqueue:(ReportItem*)item;
- (NSUInteger)size;
- (void)save;
@end

 