//
// ReportFetcher.h
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ReportItem;
typedef void (^ReportCompletion)(id result, NSError *error);
@interface ReportFetcher : NSObject
- (void)report:(ReportItem*)item completion:(ReportCompletion)comletion;
@end
