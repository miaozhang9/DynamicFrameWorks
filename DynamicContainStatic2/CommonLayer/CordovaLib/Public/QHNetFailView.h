//
//  YZTNetFailView.h
//  PANewToapAPP
//
//  Created by Apple on 16/3/29.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  QHNetFailView;

typedef NS_ENUM(NSInteger, QHNetFailViewType) {
    QHNetFailViewTypeStatic,     // 静态界面(默认)
    QHNetFailViewTypeDynamic,    // 动态界面，可以点击
};
//要有点击效果则需实现协议方法
@protocol QHNetFailViewDelegate <NSObject>

@optional
- (void)netFailView:(QHNetFailView *)failView didClickGesture:(UITapGestureRecognizer *)tapGesture;

@end

@interface QHNetFailView : UIView

@property (nonatomic, copy) NSString *messageStr;
@property (nonatomic, weak) id<QHNetFailViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withFailViewType:(QHNetFailViewType)failViewType;

@end
