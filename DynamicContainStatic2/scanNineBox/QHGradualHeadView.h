//
//  QHGradualView.h
//  QHLoanlib
//
//  Created by guopengwen on 2017/5/12.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QHGradualHeadViewDelegate <NSObject>

- (void)clickradualHeadViewScanButton:(UIButton *)btn;

@end

@interface QHGradualHeadView :UICollectionReusableView

@property (nonatomic, weak) id<QHGradualHeadViewDelegate> delegate;

@property (nonatomic, strong) UIButton *scanBtn;

@end
