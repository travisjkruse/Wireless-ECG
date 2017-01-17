//
//  ECGDataSource.h
//  Template
//
//  Created by Travis Kruse on 11/30/13.
//  Copyright (c) 2013 Travis Kruse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"

@protocol ECGDataDelegate <NSObject>
- (void)dataReceived;
@end

@interface ECGDataSource : NSObject<DataSourceDelegate>
@property (retain) id<ECGDataDelegate> delegate;
+ (ECGDataSource *)initWithBufferSize : (NSUInteger)bufferSize;
- (NSArray *)PlotDataYofRange: (NSRange)range;
- (NSUInteger)count;
- (void)changeBias:(CGFloat)bias changeAmplification:(CGFloat)amplification;
@end
