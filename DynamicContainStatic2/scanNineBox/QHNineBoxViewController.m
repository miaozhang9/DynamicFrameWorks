//
//  NineBoxViewController.m
//  QHLoanlib
//
//  Created by guopengwen on 2017/5/8.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import "QHNineBoxViewController.h"
#import "QHViewController.h"
#import "QHScanQRCodeViewController.h"
#import "QHAlertManager.h"
#import "QHLoanDoorBundle.h"
#import "QHEGOCache.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


@interface QHNineBoxViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, strong) UICollectionView *defultCollectionView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UIButton *lastDeleteBtn;

@end

@implementation QHNineBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _titleStr;
    [self addLeftBarButton];
    [self.view addSubview:self.scanBtn];

    //长按手势添加到self.collectionView上面
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
    [self.defultCollectionView addGestureRecognizer:_longPress];
    [self.view addSubview:self.defultCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_lastDeleteBtn) {
        _lastDeleteBtn.hidden = YES;
    }
}

#pragma - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kWidth - 50)/3.0, (kWidth - 50)/3.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NineBoxCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NineBoxCollectionCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArr[indexPath.item];
    NSString *title = [NSString stringWithFormat:@"链接 %ld",indexPath.item];
    [cell updateCellWithTitle:title time:[dic objectForKey:@"time"]];
    cell.btnDelete.hidden = YES;
    return cell;
}

#pragma - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArr[indexPath.item];
    NSString *urlStr = [dic objectForKey:@"URL"];
    if (urlStr) {
        QHViewController *vc = [[QHViewController alloc] init];
        vc.startPage = urlStr;
        vc.baseUserAgent = @"ToCred_iOS";
        if (self.navigationController) {
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

#pragma - action

- (void)clickScanButton {
    [self checkScanQrCodeAuthorizationStatus];
}

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
            if (_lastDeleteBtn) {
                _lastDeleteBtn.hidden = YES;
            }
            NSIndexPath *selectIndexPath = [self.defultCollectionView indexPathForItemAtPoint:[_longPress locationInView:self.defultCollectionView]];
            if (selectIndexPath) {
                // 找到当前的cell
                NineBoxCollectionCell *cell = (NineBoxCollectionCell *)[self.defultCollectionView cellForItemAtIndexPath:selectIndexPath];
                // 定义cell的时候btn是隐藏的, 在这里设置为NO
                [cell.btnDelete setHidden:NO];
                cell.btnDelete.tag = selectIndexPath.item;
                //添加删除的点击事件
                [cell.btnDelete addTarget:self action:@selector(btnDelete:) forControlEvents:UIControlEventTouchUpInside];
                [_defultCollectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
                _lastDeleteBtn = cell.btnDelete;
            }else {
                _lastDeleteBtn = nil;
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

- (void)btnDelete:(UIButton *)btn{
    // cell的隐藏删除设置
    NSIndexPath *selectIndexPath = [self.defultCollectionView indexPathForItemAtPoint:[_longPress locationInView:self.defultCollectionView]];
    // 找到当前的cell
    NineBoxCollectionCell *cell = (NineBoxCollectionCell *)[self.defultCollectionView cellForItemAtIndexPath:selectIndexPath];
    cell.btnDelete.hidden = NO;
    [self showAlertWithMessage:@"是否删除二维码跳转链接？" index:btn.tag];
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

- (void)addLeftBarButton {
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 60, 44);
    UIImage * bImage = [UIImage imageNamed:@"BarArrowLeft" inBundle:[QHLoanDoorBundle bundle] compatibleWithTraitCollection:nil];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [btn addTarget: self action: @selector(leftBarBtnAction) forControlEvents: UIControlEventTouchUpInside];
    [btn setImage: bImage forState: UIControlStateNormal];
    UIBarButtonItem * lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    self.navigationItem.leftBarButtonItem = lb;
}

#pragma mark -- getter 

- (UIButton *)scanBtn {
    if (!_scanBtn) {
        self.scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.frame = CGRectMake(40, 80, kWidth - 80, 40);
        [_scanBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
        [_scanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(clickScanButton) forControlEvents:UIControlEventTouchUpInside];
        _scanBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _scanBtn.layer.borderWidth = 1;
    }
    return _scanBtn;
}

- (UICollectionView *)defultCollectionView {
    if (!_defultCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        CGFloat h = CGRectGetMaxY(_scanBtn.frame) + 10;
        self.defultCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, h, kWidth, kHeight - h) collectionViewLayout:layout];
        _defultCollectionView.backgroundColor = [UIColor whiteColor];
        _defultCollectionView.delegate = self;
        _defultCollectionView.dataSource = self;
        _defultCollectionView.contentInset = UIEdgeInsetsMake(10, 20, 10, 20);
        [_defultCollectionView registerClass:[NineBoxCollectionCell class] forCellWithReuseIdentifier:@"NineBoxCollectionCell"];
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

@interface NineBoxCollectionCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat totalHeight;

@end

@implementation NineBoxCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _totalWidth = self.frame.size.width;
        _totalHeight = self.frame.size.height;
        
        self.bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _bgView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_bgView];
        
        [_bgView addSubview:self.titleLabel];
        [_bgView addSubview:self.subTitleLabel];
        [_bgView addSubview:self.btnDelete];
    }
    return self;
}

- (void)updateCellWithTitle:(NSString *)title time:(NSString *)time {
    _titleLabel.text = title;
    _subTitleLabel.text = time;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _totalHeight/2.0 - 30, _totalWidth, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _totalHeight/2.0 - 10, _totalWidth, _totalHeight/2.0)];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return _subTitleLabel;
}

- (UIButton *)btnDelete {
    if (!_btnDelete) {
        self.btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDelete.frame = CGRectMake(_totalWidth-20, 0, 20, 20);
        _btnDelete.backgroundColor = [UIColor clearColor];
        _btnDelete.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnDelete.layer.borderWidth = 0.5;
        [_btnDelete setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnDelete setTitle:@"X" forState:UIControlStateNormal];
    }
    return _btnDelete;
}

@end

