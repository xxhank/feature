//
// SSLogger.h
// ReportEngine
//
// Created by wangchaojs02 on 16/4/19.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SSLogInfo(fmt, ...) NSLog(@"Info:<%s:%d %s>" fmt, strrchr(__FILE__, '/') + 1, __LINE__, __FUNCTION__,##__VA_ARGS__)
#define SSLogWarning(fmt, ...) NSLog(@"Warn:<%s:%d %s>" fmt, strrchr(__FILE__, '/') + 1, __LINE__, __FUNCTION__,##__VA_ARGS__)
#define SSLogError(fmt, ...) NSLog(@"Error:<%s:%d %s>" fmt, strrchr(__FILE__, '/') + 1, __LINE__, __FUNCTION__,##__VA_ARGS__)
