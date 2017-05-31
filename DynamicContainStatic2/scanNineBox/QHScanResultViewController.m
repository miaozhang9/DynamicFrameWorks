//
//  QHScanResultViewController.m
//  QHLoanlib
//
//  Created by guopengwen on 2017/5/12.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import "QHScanResultViewController.h"
#import "QHViewController.h"
#import "QHScanQRCodeViewController.h"
#import "QHScanResultCollectionCell.h"
#import "QHAlertManager.h"
#import "QHLoanDoorBundle.h"
#import "QHEGOCache.h"
#import "UIColor+QH.h"
#import "QHGradualImage.h"
#import "QHGradualHeadView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface QHScanResultViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, QHGradualHeadViewDelegate>

@property (nonatomic, strong) QHGradualImage *gradualImage;

@property (nonatomic, strong) UIImage *navImg;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, strong) UICollectionView *defultCollectionView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation QHScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
}

#pragma - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kWidth - 58)/3.0, (kWidth - 58)/3.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kWidth, 148);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QHScanResultCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QHScanResultCollectionCell" forIndexPath:indexPath];
    NSString *title = [NSString stringWithFormat:@"链接 %ld",indexPath.item];
    [cell updateCellWithTitle:title];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    QHGradualHeadView *gradualView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QHGradualHeadView" forIndexPath:indexPath];
    gradualView.delegate = self;
    gradualView.scanBtn.tag = indexPath.section * 1000 + indexPath.item;
    return gradualView;
}

#pragma - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.item];
    NSString *urlStr = [dic objectForKey:@"URL"];
    if (urlStr) {
        QHViewController *vc = [[QHViewController alloc] init];
        vc.startPage = urlStr;
        if (self.navigationController) {
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

#pragma mark - QHGradualHeadViewDelegate

- (void)clickradualHeadViewScanButton:(UIButton *)btn {
    [self checkScanQrCodeAuthorizationStatus];
}

#pragma mark - action

- (void)leftBarBtnAction
{
    NSArray *vcArr = self.navigationController.viewControllers;
    if (vcArr.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)lonePressMoving: (UILongPressGestureRecognizer *)longPress
{
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *selectIndexPath = [self.defultCollectionView indexPathForItemAtPoint:[_longPress locationInView:self.defultCollectionView]];
            if (selectIndexPath) {
                [self showAlertWithMessage:@"是否删除二维码跳转链接？" index:selectIndexPath.item];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.defultCollectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.defultCollectionView endInteractiveMovement];
            break;
        }
        default: [self.defultCollectionView cancelInteractiveMovement];
            break;
    }
}

- (void)showAlertWithMessage:(NSString *)message index:(NSInteger)index {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    __weak typeof(self) weakSelf = self;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.dataArr removeObjectAtIndex:index];
        [[QHEGOCache globalCache] setObject:_dataArr forKey:@"LinkListCache"];
        [strongSelf.defultCollectionView reloadData];
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    } ]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.defultCollectionView reloadData];
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    } ]];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}


- (void)checkScanQrCodeAuthorizationStatus
{
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!hasCamera) {
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        [self presentScanQRcodeViewController];
        
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        __weak typeof(self) weakSelf = self;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf presentScanQRcodeViewController];
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            QHAlertManager *alertManager = [QHAlertManager shareAlertManager];
            alertManager.viewController = self;
            [alertManager showAlertMessageWithMessage:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"];
        });
    }
}

- (void)presentScanQRcodeViewController {
    QHScanQRCodeViewController *vc = [QHScanQRCodeViewController new];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    __weak typeof(self) weakSelf = self;
    vc.scanCodeResult = ^void(NSDictionary *dic){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *qrCode = [dic objectForKey:@"qrCode"];
        if (qrCode) {
            [strongSelf addUrlAndTitle:qrCode];
        }
        [navVC dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)addUrlAndTitle:(NSString *)url {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *dic = @{@"URL":url,@"time":strDate};
    [self.dataArr addObject:dic];
    [[QHEGOCache globalCache] setObject:_dataArr forKey:@"LinkListCache"];
    [self.defultCollectionView reloadData];
}

#pragma init UI

- (void)setupView {
    self.view.backgroundColor = [UIColor qh_colorWithHexString:@"#efeff4"];
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.defultCollectionView addGestureRecognizer:_longPress];
    [self.view addSubview:self.defultCollectionView];
}

- (void)initNavigationBar {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:self.navImg forBarMetrics:UIBarMetricsDefault];
    // 去除UINavigationbar下边的黑线
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationItem.title = @"扫描二维码";
    [self addLeftBarButton];
}

- (void)addLeftBarButton {
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 60, 44);
    UIImage * bImage = [UIImage imageNamed:@"BarArrowLeftWhite" inBundle:[QHLoanDoorBundle bundle] compatibleWithTraitCollection:nil];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.tintColor = [UIColor whiteColor];
    [btn setTintColor:[UIColor whiteColor]];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [btn addTarget: self action: @selector(leftBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
    [btn setImage: bImage forState: UIControlStateNormal];
    UIBarButtonItem * lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    self.navigationItem.leftBarButtonItem = lb;
}

#pragma mark -- getter

- (QHGradualImage *)gradualImage {
    if (!_gradualImage) {
        self.gradualImage = [[QHGradualImage alloc] init];
    }
    return _gradualImage;
}

- (UIImage *)navImg {
    if (!_navImg) {
        self.navImg = [self.gradualImage clipImageWithRect:CGRectMake(0, 0, kWidth, 64) image:[self.gradualImage createCircleGradualImageWithRect:CGRectMake(0, 0, kWidth, 212) startColor:[UIColor qh_colorWithHexString:@"#1eb6ee"] endColor:[UIColor qh_colorWithHexString:@"#2274f9"]]];
    }
    return _navImg;
}

- (UICollectionView *)defultCollectionView {
    if (!_defultCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(15, 14, 0, 14);
        self.defultCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) collectionViewLayout:layout];
        _defultCollectionView.backgroundColor = [UIColor clearColor];
        _defultCollectionView.delegate = self;
        _defultCollectionView.dataSource = self;
        //_defultCollectionView.contentInset = UIEdgeInsetsMake(10, 20, 10, 20);
        [_defultCollectionView registerClass:[QHScanResultCollectionCell class] forCellWithReuseIdentifier:@"QHScanResultCollectionCell"];
        [_defultCollectionView registerClass:[QHGradualHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QHGradualHeadView"];
    }
    return _defultCollectionView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [(NSArray *)[[QHEGOCache globalCache] objectForKey:@"LinkListCache"] mutableCopy];
        if (!_dataArr) {
            self.dataArr = [NSMutableArray array];
        }
    }
    return _dataArr;
}


@end
