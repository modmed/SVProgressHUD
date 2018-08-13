//
//  MMLogoAnimatedView.m
//  SVProgressHUD
//
//  Created by Jing Wei Li on 8/9/18.
//  Copyright © 2018 Modernizing Medicine. All rights reserved.
//

#import "MMLogoAnimatedView.h"

static NSString * const ringAnimationKey = @"ringAnimationKey";
static NSString * const heartbeatAnimationKey = @"heartbeatAnimationKey";
static CGFloat const ringStrokeWidth = 2.0;
static CGFloat const heartbeatStrokeWidth = 5.0;

@interface MMLogoAnimatedView()

@property (nonatomic, strong) CAShapeLayer *ringLayer;
@property (nonatomic, strong) CAShapeLayer *heartbeatLayer;

@end

@implementation MMLogoAnimatedView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.ringLayer removeFromSuperlayer];
        [self.heartbeatLayer removeFromSuperlayer];
        self.ringLayer = nil;
        self.heartbeatLayer = nil;
    }
}

- (void)layoutAnimatedLayer {
    self.ringLayer = [self createRingLayer];
    self.heartbeatLayer = [self createHeartbeatLayer];
    [self.layer addSublayer:self.ringLayer];
    [self.layer addSublayer:self.heartbeatLayer];
}

- (void)setFrame:(CGRect)frame {
    if(!CGRectEqualToRect(frame, super.frame)) {
        [super setFrame:frame];
        if(self.superview) {
            [self layoutAnimatedLayer];
        }
    }
    
}

- (CAShapeLayer *)createRingLayer {
    if (!self.ringLayer) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        CGFloat centerLength = self.offsetToCenter + (self.diameter / 2.0);
        [path addArcWithCenter:CGPointMake(centerLength, centerLength)
                        radius:self.diameter / 2
                    startAngle:0.09 * M_PI
                      endAngle:2.09 * M_PI
                     clockwise:YES];
        
        self.ringLayer = [CAShapeLayer layer];
        CAAnimationGroup *animationGroup = [self createReversibleAnimationOnLayer:self.ringLayer
                                                                   fromBezierPath:path
                                                                      strokeWidth:ringStrokeWidth];
        
        [self.ringLayer addAnimation:animationGroup forKey:ringAnimationKey];
    }
    
    return self.ringLayer;
}

- (CAShapeLayer *)createHeartbeatLayer {
    if (!self.heartbeatLayer) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(self.offsetToCenter + self.diameter * 0.06, self.offsetToCenter + self.diameter * 0.69)];
        [path addLineToPoint:CGPointMake(self.offsetToCenter + self.diameter * 0.25, self.offsetToCenter + self.diameter * 0.69)];
        [path addLineToPoint:CGPointMake(self.offsetToCenter + self.diameter * 0.33, self.offsetToCenter + self.diameter * 0.41)];
        [path addLineToPoint:CGPointMake(self.offsetToCenter + self.diameter * 0.46, self.offsetToCenter + self.diameter * 0.76)];
        [path addLineToPoint:CGPointMake(self.offsetToCenter + self.diameter * 0.63, self.offsetToCenter + self.diameter * 0.24)];
        [path addLineToPoint:CGPointMake(self.offsetToCenter + self.diameter * 0.73, self.offsetToCenter + self.diameter * 0.62)];
        [path addLineToPoint:CGPointMake(self.offsetToCenter + self.diameter * 0.95, self.offsetToCenter + self.diameter * 0.62)];
        
        self.heartbeatLayer = [CAShapeLayer layer];
        CAAnimationGroup *animationGroup = [self createReversibleAnimationOnLayer:self.heartbeatLayer
                                                                   fromBezierPath:path
                                                                      strokeWidth:heartbeatStrokeWidth];
        [self.heartbeatLayer addAnimation:animationGroup forKey:heartbeatAnimationKey];
    }
    
    return self.heartbeatLayer;
}

- (CAAnimationGroup *)createReversibleAnimationOnLayer:(CAShapeLayer *)shapeLayer
                                        fromBezierPath:(UIBezierPath *)bezierPath
                                           strokeWidth:(CGFloat)strokeWidth {
    
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = self.strokeColor.CGColor;
    shapeLayer.lineWidth = strokeWidth;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    
    CABasicAnimation *forwardAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    forwardAnimation.fromValue = @1.0;
    forwardAnimation.toValue = @0.0;
    forwardAnimation.duration = self.duration;
    forwardAnimation.beginTime = 0.0;
    
    CABasicAnimation *reverseAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    reverseAnimation.fromValue = @1.0;
    reverseAnimation.toValue = @0.0;
    reverseAnimation.duration = self.duration;
    reverseAnimation.beginTime = self.duration;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[forwardAnimation, reverseAnimation];
    animationGroup.repeatCount = INFINITY;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.autoreverses = YES;
    animationGroup.duration = self.duration * 2;
    
    return animationGroup;
}

@end
