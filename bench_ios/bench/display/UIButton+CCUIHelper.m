//
//  UIButton+CCUIHelper.m
//  bench_ios
//
//  Created by gwh on 2018/3/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIButton+CCUIHelper.h"
#import "CC_Share.h"

@implementation UIButton(UIButton)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([CC_Share shareInstance].ccDebug) {
        [super touchesBegan:touches withEvent:event];
    }
}

@end
