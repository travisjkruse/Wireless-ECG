//
//  PlotViewController.m
//  Template
//
//  Created by Travis Kruse on 11/30/13.
//  Copyright (c) 2013 Travis Kruse. All rights reserved.
//

#import "PlotViewController.h"

@interface PlotViewController ()
@property (strong, nonatomic) ECGDataSource *ecgdata;
@property (strong, nonatomic) PlotView *plotView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISlider *amplificationSlider;
@property (weak, nonatomic) IBOutlet UISlider *biasSlider;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@end
@implementation PlotViewController

/*
 -(void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 NSLog(@"scrollViewDidScroll called");
 //    CGPoint neworigin = self.plotView.origin;
 //    neworigin.x=-scrollView.contentOffset.x;
 //    self.plotView.origin=neworigin;
 //      [self.plotView setNeedsDisplay];
 }
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.ecgdata = [ECGDataSource initWithBufferSize:200];
    self.ecgdata.delegate = self;
    self.deviceNameLabel.text = self.deviceName;
    self.biasSlider.minimumValue = 0;
    self.biasSlider.maximumValue = 3;
    self.biasSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat:@"%@bias", self.deviceName]];
    self.amplificationSlider.minimumValue = 0;
    self.amplificationSlider.maximumValue = 2;
    self.amplificationSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat:@"%@amp", self.deviceName]];
    [self.ecgdata changeBias:self.biasSlider.value changeAmplification:self.amplificationSlider.value];
}

- (void)viewDidAppear:(BOOL)animated
{
    //    NSLog(@"viewDidAppear");
    CGRect scrollFrame;
    scrollFrame.origin = self.view.bounds.origin;
    scrollFrame.size.width = self.view.bounds.size.width;
    scrollFrame.size.height = 300;
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    self.plotView = [[PlotView alloc] initWithFrame:scrollFrame];
    [self.plotView setBackgroundColor:[UIColor whiteColor]];
    self.plotView.delegate=self;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.plotView];
    self.scrollView.contentSize = self.plotView.bounds.size;
    CGPoint startpoint;
    startpoint.x=self.plotView.bounds.origin.x;
    startpoint.y=self.plotView.bounds.origin.y + self.plotView.bounds.size.height/2.0;
    self.plotView.origin=startpoint;
    //    NSLog(@"origin %f %f",startpoint.x,startpoint.y);
    [self.plotView setNeedsDisplay];
}

- (void)dataReceived
{
    // adjust scrollview size
    CGSize newsize=CGSizeMake((CGFloat)[self.ecgdata count]+self.scrollView.bounds.size.width/2.0, self.plotView.bounds.size.height);
    self.scrollView.contentSize=newsize;
    
    // adjust from of view accordingly
    CGRect newFrame = self.plotView.frame;
    newFrame.size.width = newsize.width;
    newFrame.size.height = newsize.height;
    [self.plotView setFrame:newFrame];
    
    [self.plotView setNeedsDisplay];
}

- (NSArray *)DataYforRange: (NSRange)range withSourceNumber:(NSInteger)index
{
    //    NSLog(@"called DataYforRange %d %d",range.location,range.length);
    return [self.ecgdata PlotDataYofRange: (NSRange)range];
}

- (IBAction)changeAmplification:(id)sender {
    [self.ecgdata changeBias:self.biasSlider.value changeAmplification:self.amplificationSlider.value];
    [[NSUserDefaults standardUserDefaults] setFloat:self.amplificationSlider.value forKey:[NSString stringWithFormat:@"%@amp", self.deviceName]];
}

- (IBAction)changeBias:(id)sender {
    [self.ecgdata changeBias:self.biasSlider.value changeAmplification:self.amplificationSlider.value];
    [[NSUserDefaults standardUserDefaults] setFloat:self.biasSlider.value forKey:[NSString stringWithFormat:@"%@bias", self.deviceName]];
}

@end
