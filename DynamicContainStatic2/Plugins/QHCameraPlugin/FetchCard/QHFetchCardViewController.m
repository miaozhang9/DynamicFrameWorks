//
//  QHFetchCardViewController.m
//  PANewToapAPP
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "FetchCardCameraCover.h"
#import "QHFetchCardViewController.h"
#import "QHCameraImageHelper.h"
#import "QHMasonry.h"
#import "QHLoanDoorBundle.h"
#import "UIImage+QH.h"
#import "QHCode_message.h"
#import "UIView+QH.h"

@interface QHFetchCardViewController ()<QHCameraImageHelperDelegate>
//UI
@property (nonatomic, strong) UIView *transformView;
@property (nonatomic, strong) QHCameraImageHelper *cameraHelper;
@property (nonatomic, strong) FetchCardCameraCover *cameraCover;
@property (nonatomic, strong) UIView *contentLayer;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *leftButtun;
@property (nonatomic, assign) CGRect alphaRect;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *userImageView;
//拍摄页文字1
@property (nonatomic, strong) UILabel *guideLab;
@property (nonatomic, strong) UIButton *cameraBtn;

@end

@implementation QHFetchCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qh_initUI];
    [self.cameraHelper startRunning];
    [self qh_addCancelBtnIfPresented];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.cameraHelper stopRunning];
}

#pragma mark - qhCameraImageHelperDelegate

//获取图片
- (void)didFinishedCapture:(UIImage *)img{

    img = [[UIImage alloc] initWithCGImage:img.CGImage scale:1 orientation:UIImageOrientationUp];

    img = [img imageCompressForWidth:img targetWidth:1280];

    [self.cameraHelper stopRunning];
    [self.view layoutIfNeeded];

    CGFloat x = self.contentLayer.qh_left/[self screenHeight]*img.size.width;
    CGFloat width = [self alpahSize].width/[self screenHeight]*img.size.width;
    CGFloat height = [self alpahSize].height/[self alpahSize].width*img.size.height;
    CGFloat y = (img.size.height - height)/2.0;
    //will delete
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //

    img = [img qh_getSubImageInRect:CGRectMake(x, y, width, height)];

    //will delete
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //

    if (self.cameraCompleteAction) {
        self.cameraCompleteAction(img, nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{

}

//聚焦
- (void)foucusStatus:(BOOL)isAdjusting{

}

#pragma mark - private

- (void)qh_initUI{
    __weak typeof(self) weakself = self;
    [self.view addSubview:self.transformView];
    [self.transformView addSubview:self.cameraCover];
    [self.transformView addSubview:self.contentLayer];
    [self.transformView addSubview:self.cameraBtn];
    [self.contentLayer addSubview:self.textLabel];
    [self.contentLayer addSubview:self.userImageView];

    [self.transformView qhMas_remakeConstraints:^(QHMASConstraintMaker *make) {
        make.width.equalTo(weakself.view.qhMas_height);
        make.height.equalTo(weakself.view.qhMas_width);
        make.center.equalTo(weakself.view);
    }];
    [self.cameraCover qhMas_remakeConstraints:^(QHMASConstraintMaker *make) {
        make.edges.equalTo(weakself.transformView);
    }];
    [self.contentLayer qhMas_remakeConstraints:^(QHMASConstraintMaker *make) {
        make.size.qhMas_equalTo([weakself alpahSize]);
        make.centerY.equalTo(weakself.transformView);
        make.centerX.equalTo(weakself.transformView).offset(-[self alpahCenterXoffSet]);
    }];
    self.isIconLeft = YES;
    if (self.isIconLeft) {
        [self.userImageView qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.left.equalTo(weakself.contentLayer).offset(14);
            make.centerY.equalTo(weakself.contentLayer).offset(-20);
            make.size.qhMas_equalTo(weakself.argIcon.size);
        }];
        [self.textLabel qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.left.equalTo(weakself.userImageView.qhMas_right).offset(14);
            make.right.equalTo(weakself.contentLayer).offset(-14);
            make.centerY.equalTo(weakself.contentLayer);
        }];
    }
    else{
        [self.userImageView qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.right.equalTo(weakself.contentLayer).offset(-14);
            make.centerY.equalTo(weakself.contentLayer).offset(-20);
            make.size.qhMas_equalTo(weakself.argIcon.size);
        }];
        [self.textLabel qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(weakself.userImageView.qhMas_left).offset(-14);
            make.left.equalTo(weakself.contentLayer).offset(14);
            make.centerY.equalTo(weakself.contentLayer);
        }];
    }
    [self.view layoutIfNeeded];
    self.alphaRect = self.contentLayer.frame;
    [self.cameraCover resetAlphaArea:self.alphaRect];
    [self qh_addColorRadius];
    [self.cameraBtn qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
        make.centerY.equalTo(weakself.transformView);
        make.centerX.equalTo(weakself.transformView.qhMas_right).offset(-([self screenHeight] - CGRectGetMaxX(self.alphaRect))/2.0);
        make.size.qhMas_equalTo(CGSizeMake(70, 70));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:self.transformView];
    });

}

- (void)qh_fetchOCRIdentityCardInfo:(UIImage *)img{

}

///上传身份证图片到服务器
- (void)qh_uploadAllImageToServer{

}

- (void)leftBtnItemAction{
    if (self.cameraCompleteAction) {
        self.cameraCompleteAction(nil, QHMsgAbandonUsePlugin);
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)qh_addCancelBtnIfPresented{
    if (!self.navigationController) {
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.transformView addSubview:btn];
        [btn addTarget:self action:@selector(leftBtnItemAction) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        [btn qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.right.equalTo(weakSelf.transformView).offset(-14);
            make.centerY.equalTo(weakSelf.transformView.qhMas_bottom).offset(-32);
            make.size.qhMas_equalTo(CGSizeMake(80, 30));
        }];
    }
}

- (void)qh_confirm{
    [self qh_uploadAllImageToServer];
}


- (void)qh_captureStillImage{
    [self.cameraHelper captureStillImage];
}

- (void)qh_addColorRadius{

    for (int i=0; i<4; i++) {
        QHFetchCardAlphaRect *r = [[QHFetchCardAlphaRect alloc] initWithRotation:M_PI/2.0*i color:[UIColor redColor] lineWidth:2.0];
        [self.contentLayer addSubview:r];
        __weak typeof(self) weakself = self;
        [r qhMas_makeConstraints:^(QHMASConstraintMaker *make) {
            make.size.qhMas_equalTo(CGSizeMake(35, 35));
            if (i==0) {
                make.centerX.equalTo(weakself.contentLayer.qhMas_left);
                make.centerY.equalTo(weakself.contentLayer.qhMas_top);
            }
            else if (i==1){
                make.centerX.equalTo(weakself.contentLayer.qhMas_right);
                make.centerY.equalTo(weakself.contentLayer.qhMas_top);
            }
            else if (i==2){
                make.centerX.equalTo(weakself.contentLayer.qhMas_right);
                make.centerY.equalTo(weakself.contentLayer.qhMas_bottom);
            }
            else{
                make.centerX.equalTo(weakself.contentLayer.qhMas_left);
                make.centerY.equalTo(weakself.contentLayer.qhMas_bottom);
            }

        }];
    }
}

#pragma mark - get & set

- (QHCameraImageHelper *)cameraCover{
    if (!_cameraCover) {
        _cameraCover = [[FetchCardCameraCover alloc] initWithFrame:CGRectZero bgColor:[UIColor colorWithWhite:0 alpha:0.2] alphaArea:self.alphaRect alphaAreaRadius:10.0];
    }
    return _cameraCover;
}

- (QHCameraImageHelper *)cameraHelper{
    if (!_cameraHelper) {
        _cameraHelper = [[QHCameraImageHelper alloc] initWithDelegate:self embedPreviewInView:self.view fullImage:YES];
    }
    return _cameraHelper;
}

- (UIButton *)leftButtun{
    if (!_leftButtun) {
        _leftButtun = [[UIButton alloc] init];
        [_leftButtun setTitle:@"取消" forState:UIControlStateNormal];
        [_leftButtun addTarget:self action:@selector(leftBtnItemAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButtun;
}

- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc] init];
        [_cameraBtn setImage:[QHLoanDoorBundle imageNamed:@"FetchCard_cameraBtn"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(qh_captureStillImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (UIView *)contentLayer{
    if (!_contentLayer) {
        _contentLayer = [[UIView alloc] init];
//        _contentLayer.alpha = 0.1;
    }
    return _contentLayer;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.text = self.argText;
    }
    return _textLabel;
}

- (UIImageView *)userImageView{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.image = [self.argIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _userImageView;
}

- (UIView *)transformView{
    if (!_transformView) {
        _transformView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self screenHeight], [self screenWidth])];
        _transformView.transform = CGAffineTransformMakeRotation(M_PI/2.0);
    }
    return _transformView;
}

- (CGFloat)screenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}

- (CGFloat)screenWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}

- (CGFloat)rightMixWidth{
    return 90;
}

- (CGSize)alpahSize{
    //左70 右90
    CGFloat estimateHeight = [self screenWidth]-80;
    CGFloat estimateWidth = estimateHeight * 85.6/54.0;
    if (([self screenHeight] - estimateWidth)/2.0+[self alpahCenterXoffSet] < [self rightMixWidth]) {
        estimateWidth = [self screenHeight] - ([self rightMixWidth]*2.0 - [self alpahCenterXoffSet]);
        estimateHeight = estimateWidth *54.0/85.6;
    }
    return CGSizeMake(estimateWidth, estimateHeight);
}

- (CGFloat)alpahCenterXoffSet{
    return 30;
}

@end





