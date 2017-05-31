//
//  FetchCardCameraCover.m
//  PANewToapAPP
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "FetchCardCameraCover.h"

@interface FetchCardCameraCover()

@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, assign) CGRect alphaRect;

@property (nonatomic, assign) CGFloat radius;

@end

@implementation FetchCardCameraCover

- (instancetype)initWithFrame:(CGRect)frame
                      bgColor:(UIColor *)bgColor
                    alphaArea:(CGRect)alphaRect
              alphaAreaRadius:(CGFloat)radius{
    if (self = [super initWithFrame:frame]) {
        _bgColor = bgColor;
        _alphaRect = alphaRect;
        _radius = radius;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)resetAlphaArea:(CGRect)alphaRect{
    self.alphaRect = alphaRect;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:[self originalStartPoint]];
    for (int i=0; i<4; i++) {
        [bezierPath addLineToPoint:[self startArcPoint:i]];
        [bezierPath addArcWithCenter:[self circlePoint:i] radius:_radius startAngle:(0+0.5*i)*M_PI endAngle:(0.5+0.5*i)*M_PI clockwise:YES];
    }
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(rect)+0.1, CGRectGetMinY(rect))];
    [bezierPath addLineToPoint:[self originalStartPoint]];
    
    [_bgColor setFill];
    [bezierPath fill];
    
}

- (CGPoint)circlePoint:(NSInteger)i{
    switch (i) {
        case 0:{
           return CGPointMake(CGRectGetMaxX(_alphaRect)-_radius, CGRectGetMaxY(_alphaRect)-_radius);
        }
        case 1:{
           return CGPointMake(CGRectGetMinX(_alphaRect)+_radius, CGRectGetMaxY(_alphaRect)-_radius);
        }
        case 2:{
            return CGPointMake(CGRectGetMinX(_alphaRect)+_radius, CGRectGetMinY(_alphaRect)+_radius);
        }
        case 3:{
            return CGPointMake(CGRectGetMaxX(_alphaRect)-_radius, CGRectGetMinY(_alphaRect)+_radius);
        }
        default:
            break;
    }
    return CGPointZero;
}

- (CGPoint)startArcPoint:(NSInteger)i{
    switch (i) {
        case 0:{
            return CGPointMake(CGRectGetMaxX(_alphaRect), CGRectGetMaxY(_alphaRect)-_radius);
        }
        case 1:{
            return CGPointMake(CGRectGetMinX(_alphaRect)+_radius, CGRectGetMaxY(_alphaRect));
        }
        case 2:{
            return CGPointMake(CGRectGetMinX(_alphaRect), CGRectGetMinY(_alphaRect)+_radius);
        }
        case 3:{
            return CGPointMake(CGRectGetMaxX(_alphaRect)-_radius, CGRectGetMinY(_alphaRect));
        }
        default:
            break;
    }
    return CGPointZero;
}

- (CGPoint)originalStartPoint{
    return CGPointMake([self startArcPoint:3].x + _radius, [self startArcPoint:3].y - 0.1);
}

@end

@interface QHFetchCardAlphaRect ()

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation QHFetchCardAlphaRect

- (instancetype)initWithRotation:(CGFloat)rotation color:(UIColor *)color lineWidth:(CGFloat)lineWidth{
    if (self = [super init]){
        self.backgroundColor = [UIColor clearColor];
        self.color = color;
        self.lineWidth = lineWidth;
        self.transform = CGAffineTransformMakeRotation(rotation);
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(width, height/2.0+self.lineWidth/2.0)];
    [path addLineToPoint:CGPointMake(width/2.0+self.lineWidth/2.0, height/2.0+self.lineWidth/2.0)];
    [path addLineToPoint:CGPointMake(width/2.0+self.lineWidth/2.0, height)];
    path.lineWidth = self.lineWidth;
    [self.color setStroke];
    [path stroke];
}


@end



