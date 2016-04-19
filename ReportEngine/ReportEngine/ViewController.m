//
// ViewController.m
// ReportEngine
//
// Created by wangchaojs02 on 16/4/18.
// Copyright © 2016年 wangchaojs02. All rights reserved.
//

#import "ViewController.h"
#import "Report.h"

@interface ViewController ()
@property (nonatomic, strong) ReportEngine   *engine;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, assign) NSInteger       total;
@property (nonatomic, weak) NSTimer          *eventTimer;
@property (nonatomic, weak) NSTimer          *updateTimer;
@end

@implementation ViewController
{
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateCount:nil];

    self.engine = [[ReportEngine alloc] init];
    [self.engine start];

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(createEvent:) userInfo:nil repeats:YES];
    self.eventTimer = timer;

    timer            = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCount:) userInfo:nil repeats:YES];
    self.updateTimer = timer;
} /* viewDidLoad */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if(self.isMovingFromParentViewController)
    {
        [self.eventTimer invalidate];
        [self.updateTimer invalidate];
        [self.engine stop];
    }
}

#pragma mark -
- (void)createEvent:(id)sender
{
    if(arc4random() % 10 == 3)
    {
        self.total++;
        [self.engine traceItem:[ReportItem new]];
    }
}

- (void)updateCount:(id)sender
{
    self.countLabel.text =
        [NSString stringWithFormat:@"success %@ failed %@ total:%@ %@",
         @(self.engine.success),
         @(self.engine.failed),
         @(self.engine.pending),
         @(self.total)];
}

- (IBAction)toogleReport:(UIButton*)sender
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
