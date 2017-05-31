//
//  QHScanResultCollectionCell.m
//  QHLoanlib
//
//  Created by guopengwen on 2017/5/12.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import "QHScanResultCollectionCell.h"
#import "QHLoanDoorBundle.h"
#import "QHMasonry.h"

@interface QHScanResultCollectionCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat totalWidth;

@end


@implementation QHScanResultCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _totalWidth = self.frame.size.width;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.iconView];
    [_bgView addSubview:self.titleLabel];
    
    __weak typeof(self) weakSelf = self;
    [_bgView qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.edges.qhMas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    } ];
    
    [_iconView qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.top.qhMas_equalTo(10);
        make.centerX.qhMas_equalTo(weakSelf.bgView.qhMas_centerX);
        make.size.qhMas_equalTo(CGSizeMake(64, 64));
    }];
    
    [_titleLabel qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.top.qhMas_equalTo(weakSelf.iconView.qhMas_bottom).qhMas_offset(0);
        make.left.qhMas_equalTo(0);
        make.right.qhMas_equalTo(0);
        make.bottom.qhMas_equalTo(0);
    } ];
}


- (void)updateCellWithTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (UIView *)bgView {
    if (!_bgView) {
        self.bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        self.iconView = [[UIImageView alloc] initWithImage:[QHLoanDoorBundle imageNamed:@"link_default@2x.png"]];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

@end
