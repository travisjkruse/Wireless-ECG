//
//  ECGDataSource.m
//  Template
//
//  Created by Travis Kruse on 11/30/13.
//  Copyright (c) 2013 Travis Kruse. All rights reserved.
//

#import "ECGDataSource.h"

@interface ECGDataSource()
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic,strong) DataSource *dataSource;
@property (nonatomic) CGFloat bias;
@property (nonatomic) CGFloat amplification;
@end

@implementation ECGDataSource

+(ECGDataSource *)initWithBufferSize:(NSUInteger)bufferSize
{
    ECGDataSource *newECGData=[[ECGDataSource alloc]init];
    newECGData.dataSource=[DataSource initWithPacketLength:10 withTimerInterval:1.0/20.0];
    newECGData.dataSource.delegate=newECGData;    
    newECGData.data=[[NSMutableArray alloc]initWithCapacity:200];
    NSLog(@"ECGData initialized");
    return newECGData;
}

-(void)receivedData:(NSArray *)dataReceived
{
    for (NSNumber *number in dataReceived) {
        [self.data addObject:number];
    }
    [self.delegate dataReceived];
}

- (NSArray *)PlotDataYofRange: (NSRange)range
{
    if ([self.data count]<range.location)
    {
        NSLog(@"no data at this location");
        return nil;
    }
    if ([self.data count]<(range.location+range.length))
    {
        range.length=[self.data count]-range.location;
    }
    NSMutableArray *output = [NSMutableArray arrayWithCapacity:range.length];
    for (NSUInteger i=0; i<range.length; i++){
        [output addObject:[self.data objectAtIndex:range.location+i]];
    }
    return [output copy];
}

- (NSUInteger)count
{
    return self.data.count;
}

- (void)changeBias:(CGFloat)bias changeAmplification:(CGFloat)amplification
{
    [self.dataSource setBias:bias setAmplification:amplification];
}

@end
