//
//  MMLogoAnimatedView.h
//  SVProgressHUD
//
//  Created by Jing Wei Li on 8/9/18.
//  Copyright © 2018 Modernizing Medicine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMLogoAnimatedView : UIView

@property (nonatomic, assign) CGFloat diameter;
@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat offsetToCenter;

- (void)layoutAnimatedLayer;

@end
