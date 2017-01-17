//
//  PlotView.h
//  Template
//
//  Created by Cheung Yuihoi on 11/30/13.
//  Copyright (c) 2013 Rico Cheung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlotViewDataSource <NSObject>
@required
- (NSArray *)DataYforRange: (NSRange)range withSourceNumber: (NSInteger)index;
@end

@interface PlotView : UIView
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@property (nonatomic) NSInteger sourceNumber;
@property (retain) id<PlotViewDataSource> delegate;
@end
