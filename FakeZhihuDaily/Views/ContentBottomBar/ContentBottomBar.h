//
//  ContentBottomBar.h
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/12/3.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^buttonActions)(NSInteger index);

@interface ContentBottomBar : UIView

@property (nonatomic, copy) buttonActions actions;

@end
