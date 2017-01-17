//
//  MultiPlotViewController.m
//  Template
//
//  Created by Cheung Yuihoi on 11/30/13.
//  Copyright (c) 2013 Rico Cheung. All rights reserved.
//

#import "MultiPlotViewController.h"

@interface MultiPlotViewController ()
@property (strong, nonatomic) NSMutableArray *multiData;
@property (strong, nonatomic) NSMutableArray *multiPlotView;
@property (strong, nonatomic) NSMutableArray *multiScrollView;
@property (nonatomic) NSInteger dataSourceCount;
@end

@implementation MultiPlotViewController

- (NSInteger)dataSourceCount
{
    if (!_dataSourceCount) _dataSourceCount = [self.deviceNames count];
    return _dataSourceCount;
}

- (NSMutableArray *)deviceNames
{
    if (!_deviceNames) _deviceNames = [[NSMutableArray alloc] init];
    //[_deviceNames addObject:@"FakeECG1"];
    //[_deviceNames addObject:@"FakeECG2"];
    //[_deviceNames addObject:@"FakeECG3"];
    return _deviceNames;
}

- (NSMutableArray *)multiData
{
    if (!_multiData) _multiData = [[NSMutableArray alloc] init];
    return _multiData;
}

- (NSMutableArray *)multiPlotView
{
    if (!_multiPlotView) _multiPlotView = [[NSMutableArray alloc] init];
    return _multiPlotView;
}

- (NSMutableArray *)multiScrollView
{
    if (!_multiScrollView) _multiScrollView = [[NSMutableArray alloc] init];
    return _multiScrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    for (NSInteger i = 0; i < self.dataSourceCount; i++) {
        
        ECGDataSource *ecgdata = [ECGDataSource initWithBufferSize:200];
        ecgdata.delegate = self;
        [ecgdata changeBias:[[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat:@"%@bias", [self.deviceNames objectAtIndex:i]]] changeAmplification:[[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat:@"%@amp", [self.deviceNames objectAtIndex:i]]]];
        [self.multiData addObject:ecgdata];
        
        CGRect scrollFrame;
        scrollFrame.origin.x = self.view.bounds.origin.x;
        scrollFrame.origin.y = self.view.bounds.origin.y+self.view.bounds.size.height/self.dataSourceCount*i;
        scrollFrame.size.width = self.view.bounds.size.width;
        scrollFrame.size.height = self.view.bounds.size.height/self.dataSourceCount;
        CGRect plotFrame;
        plotFrame.origin.x = self.view.bounds.origin.x;
        plotFrame.origin.y = self.view.bounds.origin.y;
        plotFrame.size.width = self.view.bounds.size.width;
        plotFrame.size.height = self.view.bounds.size.height/self.dataSourceCount;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        PlotView *plotView = [[PlotView alloc] initWithFrame:plotFrame];
       [plotView setBackgroundColor:[UIColor whiteColor]];
        plotView.delegate=self;
        plotView.sourceNumber = i;
        [self.view addSubview:scrollView];
        [scrollView addSubview:plotView];
        scrollView.contentSize = plotView.bounds.size;
        CGPoint startpoint;
        startpoint.x=plotView.bounds.origin.x;
        startpoint.y=plotView.bounds.origin.y + plotView.bounds.size.height/2.0;
        plotView.origin=startpoint;
        [self.multiPlotView addObject:plotView];
        [self.multiScrollView addObject:scrollView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    for (NSInteger i = 0; i < self.dataSourceCount; i++) {
        PlotView *plotView = [self.multiPlotView objectAtIndex:i];
        [plotView setNeedsDisplay];
    }
}

- (void)dataReceived
{
    for (NSInteger i = 0; i < self.dataSourceCount; i++) {
        ECGDataSource *ecgdata = [self.multiData objectAtIndex:i];
        UIScrollView *scrollView = [self.multiScrollView objectAtIndex:i];
        PlotView *plotView = [self.multiPlotView objectAtIndex:i];
        CGSize newsize=CGSizeMake((CGFloat)[ecgdata count]+scrollView.bounds.size.width/2.0, plotView.bounds.size.height);
        scrollView.contentSize=newsize;
        [self.multiScrollView removeObjectAtIndex:i];
        [self.multiScrollView insertObject:scrollView atIndex:i];
        CGRect newFrame = plotView.frame;
        newFrame.size.width = newsize.width;
        newFrame.size.height = newsize.height;
        [plotView setFrame:newFrame];
        [self.multiPlotView removeObjectAtIndex:i];
        [self.multiPlotView insertObject:plotView atIndex:i];
        [plotView setNeedsDisplay];
    }
}

- (NSArray *)DataYforRange: (NSRange)range withSourceNumber:(NSInteger)index
{
    ECGDataSource *ecgdata = [self.multiData objectAtIndex:index];
    [ecgdata changeBias:[[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat:@"%@bias", [self.deviceNames objectAtIndex:index]]] changeAmplification:[[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat:@"%@amp", [self.deviceNames objectAtIndex:index]]]];
    return [ecgdata PlotDataYofRange: (NSRange)range];
}

@end
