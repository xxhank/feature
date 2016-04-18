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
    self.engine = [[ReportEngine alloc] initWithManager:[[ReportManager alloc] init]
                                                fetcher:[[ReportFetcher alloc] init]
                                               schedule:[[ReportSchedule alloc] init]];

    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(createEvent:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createEvent:(id)sender
{
    if(arc4random() % 10 == 3)
    {
        [self.engine traceItem:[ReportItem new]];
    }
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
