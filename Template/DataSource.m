//
//  DataSource.m
//  Data2
//
//  Created by Jean Olivier Brutus on 4/2/13.
//  Copyright (c) 2013 Jean Olivier Brutus. All rights reserved.
//


#import "DataSource.h"

@interface DataSource()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property NSUInteger mypacketLength;
@property double mytimerInterval;
@property (nonatomic, strong) NSTimer *mytimer;
@property (nonatomic) NSUInteger fakeECGIndex;
@property (nonatomic) NSUInteger fakeECGLength;
@property (nonatomic) NSUInteger dataPacketCounter;
@property (nonatomic, strong) NSArray *fakeECG;
@property (nonatomic) BOOL live;
@property (nonatomic) CGFloat bias;
@property (nonatomic) CGFloat amplification;

@end

@implementation DataSource

+(DataSource*)initWithPacketLength:(NSUInteger)packetLength withTimerInterval:(double)timerInterval
{
    DataSource *dataSource = [[DataSource alloc] init];
    dataSource.mypacketLength=packetLength;
    dataSource.mytimerInterval=timerInterval;
    dataSource.mytimer=[NSTimer timerWithTimeInterval:timerInterval
                                               target:dataSource
                                             selector:@selector(newData:)
                                             userInfo:nil
                                              repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:dataSource.mytimer forMode:NSRunLoopCommonModes];
    dataSource.live=true;
    //hacked//
    dataSource.bias=0.0;
    dataSource.amplification=1.0;
    //hacked//
    dataSource.fakeECG = @[
               @1035,
               @1035,
               @1041,
               @1041,
               @1041,
               @1046,
               @1057,
               @1068,
               @1078,
               @1084,
               @1089,
               @1089,
               @1089,
               @1094,
               @1105,
               @1116,
               @1126,
               @1143,
               @1164,
               @1175,
               @1180,
               @1180,
               @1196,
               @1223,
               @1250,
               @1266,
               @1287,
               @1309,
               @1335,
               @1357,
               @1378,
               @1410,
               @1448,
               @1475,
               @1485,
               @1512,
               @1533,
               @1555,
               @1582,
               @1608,
               @1630,
               @1646,
               @1646,
               @1651,
               @1651,
               @1646,
               @1619,
               @1582,
               @1555,
               @1528,
               @1496,
               @1453,
               @1410,
               @1384,
               @1362,
               @1325,
               @1287,
               @1266,
               @1234,
               @1218,
               @1201,
               @1169,
               @1148,
               @1132,
               @1126,
               @1126,
               @1121,
               @1121,
               @1116,
               @1116,
               @1116,
               @1116,
               @1110,
               @1110,
               @1105,
               @1094,
               @1094,
               @1094,
               @1100,
               @1105,
               @1105,
               @1110,
               @1110,
               @1100,
               @1100,
               @1105,
               @1105,
               @1105,
               @1105,
               @1105,
               @1094,
               @1089,
               @1089,
               @1089,
               @1078,
               @1078,
               @1073,
               @1073,
               @1073,
               @1068,
               @1062,
               @1057,
               @1057,
               @1046,
               @1052,
               @1057,
               @1057,
               @1052,
               @1046,
               @1046,
               @1035,
               @1035,
               @1041,
               @1041,
               @1035,
               @1035,
               @1035,
               @1041,
               @1041,
               @1041,
               @1041,
               @1041,
               @1035,
               @1035,
               @1030,
               @1030,
               @1035,
               @1035,
               @1035,
               @1030,
               @1030,
               @1030,
               @1030,
               @1030,
               @1030,
               @1035,
               @1035,
               @1030,
               @1035,
               @1035,
               @1025,
               @1025,
               @1025,
               @1025,
               @1035,
               @1035,
               @1035,
               @1035,
               @1035,
               @1030,
               @1030,
               @1035,
               @1041,
               @1041,
               @1041,
               @1041,
               @1041,
               @1041,
               @1035,
               @1035,
               @1041,
               @1052,
               @1078,
               @1089,
               @1089,
               @1089,
               @1084,
               @1105,
               @1132,
               @1169,
               @1185,
               @1185,
               @1185,
               @1185,
               @1180,
               @1175,
               @1148,
               @1110,
               @1084,
               @1068,
               @1062,
               @1057,
               @1035,
               @1035,
               @1025,
               @1030,
               @1030,
               @1025,
               @1025,
               @1014,
               @1014,
               @1014,
               @1019,
               @1014,
               @1003,
               @998,
               @1003,
               @1003,
               @998,
               @993,
               @918,
               @880,
               @902,
               @1110,
               @1496,
               @1999,
               @2583,
               @3129,
               @3531,
               @3595,
               @3161,
               @2272,
               @1303,
               @666,
               @500,
               @570,
               @666,
               @682,
               @661,
               @612,
               @607,
               @607,
               @607,
               @623,
               @612,
               @629,
               @682,
               @757,
               @827,
               @880,
               @918,
               @944,
               @982,
               @998,
               @1014,
               @1019,
               @1025,
               @1030,
               @1025,
               @1030,
               @1035
               ];
    
    dataSource.fakeECGLength = [dataSource.fakeECG count];
    NSLog(@"DataSource initialized");
    return dataSource;
}

////////////////////////CREATES RANDOM DATA//////////////////////////

-(void)newData:(NSTimer *)theTimer
{
    
    NSMutableArray *data = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.mypacketLength; i++) {
        NSNumber *temp = [self.fakeECG objectAtIndex:self.fakeECGIndex];
        
        CGFloat dataNumber = [temp floatValue];
        //NSLog(@"Pre-data: %f", dataNumber);
        dataNumber = (dataNumber + self.bias) * self.amplification;
        //NSLog(@"Post-data: %f", dataNumber);
        NSNumber *newNumber = [NSNumber numberWithFloat:dataNumber];
        [data addObject:newNumber];
        //[data addObject:[self.fakeECG objectAtIndex:self.fakeECGIndex]];
        self.fakeECGIndex = (self.fakeECGIndex+1)%(self.fakeECGLength-1);
    }
    [self.delegate receivedData:[data copy]];
    self.dataPacketCounter++;
//    NSLog(@"dataPacketCounter %d",self.dataPacketCounter);
    if (self.dataPacketCounter >= 200) {
        [self.mytimer invalidate];
        self.mytimer=Nil;
        self.live=false;
    }
//    NSLog(@"datasource timer excecuted");
}

////////////////////////ENDS CREATING RANDOM DATA//////////////////////////

-(void)setBias:(CGFloat)bias setAmplification:(CGFloat)amplification
{
    self.amplification = amplification;
    self.bias = (bias-1.5)*1000;
}

@end
