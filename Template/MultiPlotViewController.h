//
//  MultiPlotViewController.h
//  Template
//
//  Created by Cheung Yuihoi on 11/30/13.
//  Copyright (c) 2013 Rico Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECGDataSource.h"
#import "PlotView.h"

@interface MultiPlotViewController : UIViewController<ECGDataDelegate, PlotViewDataSource>
@property (strong, nonatomic) NSMutableArray *deviceNames;
@end
