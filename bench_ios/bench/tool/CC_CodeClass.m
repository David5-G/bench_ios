//
//  CC_CodeClass.m
//  bench_ios
//
//  Created by gwh on 2017/8/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CC_CodeClass.h"

@implementation CC_Code

+ (UIViewController *)getCurrentVC
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *rootVC = window.rootViewController;
    UIViewController *presentedViewController = rootVC.presentedViewController;
    if (presentedViewController != nil) {
        if ([presentedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nv = (UINavigationController *)presentedViewController;
            return [nv.viewControllers lastObject];
        }else{
            return presentedViewController;
        }
    }
    return nil;
}
    
+ (UIWindow *)getLastWindow{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)&&window.hidden==NO){
            return window;
        }
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

+ (UIView *)getAView{
    UIView *showV=[CC_Code getCurrentVC].view;
    if (!showV) {
        showV=[CC_Code getLastWindow];
    }
    return showV;
}

+ (void)setRadius:(float)radius view:(UIView *)view{
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:radius];
}

+ (void)setShadow:(UIColor *)color view:(UIView *)view offset:(CGSize)size opacity:(float)opacity{
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOffset = size;
    view.layer.shadowOpacity = opacity;
}

+ (void)setShadow:(UIColor *)color view:(UIView *)view{
    [self setShadow:color view:view offset:CGSizeMake(2, 5) opacity:0.5];
}

+ (void)setLineColor:(UIColor *)color width:(float)width view:(UIView *)view{
    [view.layer setBorderWidth:width];
    view.layer.borderColor = [color CGColor];
}

+ (void)setFade:(UIView *)view{
    CAGradientLayer *_gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       nil];
    [_gradLayer setColors:colors];
    //渐变起止点，point表示向量
    [_gradLayer setStartPoint:CGPointMake(0.0f, 1.0f)];
    [_gradLayer setEndPoint:CGPointMake(0.0f, 0.0f)];
    
    [_gradLayer setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [view.layer setMask:_gradLayer];
}

@end

@implementation convert

+ (NSString *)convertToJSONData:(id)infoDict
{
    if (!infoDict) {
        return @"";
    }
    if ([infoDict isKindOfClass:[NSString class]]) {
        return infoDict;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (UIColor *)colorwithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSString*)parseLabel:(NSString*)str start:(NSString *)startStr end:(NSString *)endStr includeStartEnd:(BOOL)includeStartEnd{
    NSScanner *theScanner;
    NSString *head = nil;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:str];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:startStr intoString:&head] ;
        // find end of tag
        [theScanner scanUpToString:endStr intoString:&text] ;
    }
    if (includeStartEnd) {
        text=[text stringByAppendingString:endStr];
    }else{
        text=[text stringByReplacingOccurrencesOfString:startStr withString:@""];
    }
    return text;
}

@end
