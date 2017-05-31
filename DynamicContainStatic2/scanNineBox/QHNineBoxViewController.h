//
//  QHNineBoxViewController.h
//  QHLoanlib
//
//  Created by guopengwen on 2017/5/8.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QHNineBoxViewController : UIViewController

@property (nonatomic, copy) NSString *titleStr;

@end


@interface NineBoxCollectionCell : UICollectionViewCell


@property (nonatomic, strong) UIButton *btnDelete;

- (void)updateCellWithTitle:(NSString *)title time:(NSString *)time;

@end
