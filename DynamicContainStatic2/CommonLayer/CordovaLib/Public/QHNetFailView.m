//
//  YZTNetFailView.m
//  PANewToapAPP
//
//  Created by Apple on 16/3/29.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "QHNetFailView.h"
#import "QHMasonry.h"
#import "UIColor+QH.h"
#import "QHLoanDoorBundle.h"

@interface QHNetFailView()

@property (nonatomic, weak) UILabel *mesLabel;

@end

@implementation QHNetFailView

- (instancetype)initWithFrame:(CGRect)frame withFailViewType:(QHNetFailViewType)failViewType
{
    self = [super initWithFrame:frame];
    if (self) {
        [self yzt_setupUI];
        
        if (failViewType == QHNetFailViewTypeDynamic)
        {
            [self yzt_addTapGesture];
            self.mesLabel.text = @"网络不太给力，请点击重试";
        }else{
            self.mesLabel.text = @"网络不给力，请稍后再试";
        }
    }
    return self;
}
#pragma mark private
- (void)yzt_setupUI
{
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"requestFailed" inBundle:[QHLoanDoorBundle bundle] compatibleWithTraitCollection:nil];
    [self addSubview:imageView];
    __weak typeof(self) weakself = self;
    [imageView qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.centerX.equalTo(weakself);
//        make.top.qhMas_equalTo(weakself.qhMas_top).offset(120);
        make.bottom.equalTo(weakself.qhMas_centerY);
//        make.size.qhMas_equalTo(CGSizeMake(120, 120));
    }];
    
    UILabel *messageLab = [[UILabel alloc] init];
    messageLab.font = [UIFont systemFontOfSize:14];
    messageLab.textColor = [UIColor qh_colorWithHex:0x9b9b9b];
    messageLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:messageLab];
    [messageLab qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.top.equalTo(imageView.qhMas_bottom).offset(20);
        make.centerX.equalTo(weakself);
//        make.size.qhMas_equalTo(CGSizeMake(200, 30));
    }];
    self.mesLabel = messageLab;
}
         
- (void)yzt_addTapGesture
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent:)];
    [self addGestureRecognizer:tapGesture];
    
}
#pragma mark event response
- (void)tapGestureEvent:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(netFailView:didClickGesture:)]) {
        [self.delegate netFailView:self didClickGesture:tapGesture];
    }
}

#pragma mark setter and getter
- (void)setMessageStr:(NSString *)messageStr
{
    _messageStr = messageStr;
    self.mesLabel.text = messageStr;
}

@end
