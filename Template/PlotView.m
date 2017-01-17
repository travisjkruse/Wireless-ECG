//
//  PlotView.m
//  Template
//
//  Created by Cheung Yuihoi on 11/30/13.
//  Copyright (c) 2013 Rico Cheung. All rights reserved.
//

#import "PlotView.h"
#import "AxesDrawer.h"

@implementation PlotView

- (void)setup
{
    //self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
    self.scale=1.0;
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[AxesDrawer class] drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    
    NSInteger location = self.bounds.origin.x-self.origin.x;
    NSInteger length = self.bounds.size.width;
    if (length<0) length=0;
    
    NSRange XRange = NSMakeRange(location, length);
    
    NSArray *plotData = [self.delegate DataYforRange:XRange withSourceNumber:self.sourceNumber];
    if (plotData) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        for (int i = 1; i < plotData.count; i++) {
            double startPoint = [[plotData objectAtIndex:(int)i-1] doubleValue]/50.0;
            [path moveToPoint:CGPointMake((i-1), self.bounds.size.height/2.0 - startPoint)];
            double formerPoint = [[plotData objectAtIndex:(int)i] doubleValue]/50.0;
            [path addLineToPoint:CGPointMake(i, self.bounds.size.height/2.0 - formerPoint)];
        }
        if (plotData.count > 1) {
            [path closePath];
            [[UIColor redColor] setStroke];
            [path stroke];
        }
        
    }
}


@end
