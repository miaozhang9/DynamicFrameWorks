//
//  QHCardPassportScanCodeViewController.m
//  PANewToapAPP
//
//  Created by guopengwen on 16/8/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "QHScanQRCodeViewController.h"
#import "QHLightBlackView.h"
#import "QHLoanDoorBundle.h"

#define QHScreenWidth [UIScreen mainScreen].bounds.size.width
#define QHScreenHeight [UIScreen mainScreen].bounds.size.height

@interface QHScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) QHLightBlackView *grayView;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) AVCaptureDevice            *device;
@property (nonatomic, strong) AVCaptureDeviceInput       *input;
@property (nonatomic, strong) AVCaptureMetadataOutput    *output;
@property (nonatomic, strong) AVCaptureSession           *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, assign) CGRect scanRect;

@end

@implementation QHScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描二维码";
    
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
    
    
    [self.view addSubview:self.grayView];
    [self configureSizeForScanWithRect:CGSizeMake(260, 260)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开始捕获
    [self qh_startRunningSession];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated ];
    [self qh_stopRunningSession];
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


- (void)configureSizeForScanWithRect:(CGSize)scanSize
{
     CGRect scanRect = CGRectMake((QHScreenWidth-scanSize.width)/2-20, (QHScreenHeight-scanSize.height)/2 - 84, scanSize.width + 40, scanSize.height+40);
    
     _scanRect = CGRectMake(scanRect.origin.y/QHScreenHeight, scanRect.origin.x/QHScreenWidth, scanRect.size.height/QHScreenHeight,scanRect.size.width/QHScreenWidth);
    // _scanRect = CGRectMake(0.1, 0.1 ,0.6, 0.8);
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *err = nil;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&err];
    if (!_input) {
        return;
    }
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
      //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    self.output.rectOfInterest = _scanRect;
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
}

#pragma mark --- AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ( (metadataObjects.count == 0) )
    {
        NSDictionary *error = @{@"code":@"3", @"message":@"二维码扫描失败"};
        self.scanCodeResult(error);
        return;
    }
    // 获取数据之后，取消扫描操作
    [self qh_stopRunningSession];
    for (AVMetadataObject *metadata in metadataObjects)
    {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            NSString *QRCode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            //输出扫描字符串
            [self actionForSucceedOfScan:QRCode];
            break;
        }
    }
}

- (void)actionForSucceedOfScan:(NSString *)str
{
    if (str)
    {
        NSDictionary *result = @{@"qrCode":str};
        self.scanCodeResult(result);
    } else {
        NSDictionary *error = @{@"code":@"3", @"message":@"二维码扫描失败"};
        self.scanCodeResult(error);
    }

}

#pragma mark -- pravite

- (void)qh_startRunningSession
{
    [self.grayView startAnimation];
    [self.session startRunning];
}

- (void)qh_stopRunningSession
{
    [self.grayView stopAnimation];
    [self.session stopRunning];
}

#pragma mark -- setter and getter

- (QHLightBlackView *)grayView
{
    if (!_grayView) {
        self.grayView = [[QHLightBlackView alloc] initWithFrame:CGRectMake(0, 0, 260, 260) size:260];
    }
    return _grayView;
}

@end
