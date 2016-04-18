//
// ReportDataManager.h
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportItem : NSObject

@end
@interface ReportManager : NSObject
- (void)traceItem:(ReportItem*)item;
- (ReportItem*)item;
- (void)processFailedItem:(ReportItem*)item;
- (void)processSuccessItem:(ReportItem*)item;

@end
