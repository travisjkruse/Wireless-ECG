//
//  PlotViewController.h
//  Template
//
//  Created by Travis Kruse on 11/30/13.
//  Copyright (c) 2013 Travis Kruse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECGDataSource.h"
#import "PlotView.h"

@interface PlotViewController : UIViewController<ECGDataDelegate, PlotViewDataSource>
@property (strong, nonatomic) NSString *deviceName;
@end
