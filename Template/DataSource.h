//
//  DataSource.h
//  Data2
//
//  Created by Jean Olivier Brutus on 4/2/13.
//  Copyright (c) 2013 Jean Olivier Brutus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataSourceDelegate <NSObject>
@required
- (void)receivedData:(NSArray *)dataReceived;
@end

@interface DataSource : NSObject
@property (retain) id<DataSourceDelegate> delegate;
+(DataSource *)initWithPacketLength:(NSUInteger)packetLength withTimerInterval:(double)timerInterval;
-(void)setBias:(CGFloat)bias setAmplification:(CGFloat)amplification;
@end