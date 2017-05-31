//
//  QHGradualView.m
//  QHLoanlib
//
//  Created by guopengwen on 2017/5/12.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import "QHGradualHeadView.h"
#import "UIColor+QH.h"
#import "QHGradualImage.h"
#import "QHMasonry.h"

@interface QHGradualHeadView ()

@property (nonatomic, strong) QHGradualImage *gradualImage;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation QHGradualHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame ];
    if (self) {
        [self addSubview:self.imgView];
        self.imgView.image = [self.gradualImage clipImageWithRect:CGRectMake(0, 64, self.bounds.size.width, 212) image:[self.gradualImage createCircleGradualImageWithRect:CGRectMake(0, 0, self.bounds.size.width, 212) startColor:[UIColor qh_colorWithHexString:@"#1eb6ee"] endColor:[UIColor qh_colorWithHexString:@"#2274f9"]]];
        
        [_imgView addSubview:self.scanBtn];
        __weak typeof(self) weakSelf = self;
        [_scanBtn qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.centerX.qhMas_equalTo(weakSelf.imgView.qhMas_centerX);
            make.centerY.qhMas_equalTo(weakSelf.imgView.qhMas_centerY);
            make.size.qhMas_equalTo(CGSizeMake(240, 48));
        } ];
        
    }
    return self;
}

- (void)clickScanButton:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(clickradualHeadViewScanButton:)]) {
        [_delegate clickradualHeadViewScanButton:btn];
    }
}

- (UIImageView *)imgView {
    if (!_imgView) {
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.userInteractionEnabled = YES;
    }
    return _imgView;
}

- (UIButton *)scanBtn {
    if (!_scanBtn) {
        self.scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.backgroundColor = [UIColor qh_colorWithHexString:@"#FFFFFF" alpha:0.1];
        [_scanBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
        [_scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(clickScanButton:) forControlEvents:UIControlEventTouchUpInside];
        _scanBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _scanBtn.layer.borderWidth = 1;
        _scanBtn.layer.cornerRadius = 24;
    }
    return _scanBtn;
}

- (QHGradualImage *)gradualImage {
    if (!_gradualImage) {
        self.gradualImage = [[QHGradualImage alloc] init];
    }
    return _gradualImage;
}

@end
