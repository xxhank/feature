//
// ViewController.m
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import "ViewController.h"
#import "ReportEngine.h"

@interface ViewController ()
@property (nonatomic, strong) ReportEngine *engine;
@end

@implementation ViewController
{
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.engine = [[ReportEngine alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ToogleReport:(UIButton*)sender
{
    NSString *title = [sender titleForState:UIControlStateNormal];
    BOOL      start = [title isEqualToString:@"Start"];

    [sender setTitle:start ? @"Stop" : @"Start" forState:UIControlStateNormal];

    if (start)
    {
        [self.engine start];
    }
    else
    {
        [self.engine stop];
    }
} /* ToogleReport */

@end
