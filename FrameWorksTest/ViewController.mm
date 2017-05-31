//
//  ViewController.m
//  FrameWorksTest
//
//  Created by Miaoz on 2017/5/25.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import "ViewController.h"
#import "DynamicContainStatic2.h"

@interface ViewController ()
<UITextViewDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    self.startPage = @"http://www.baidu.com";
    [super viewDidLoad];
    
    self.title = @"Native-App";
    
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    
    NSLog(@"%@", path);
    
    NSString *homePath = NSHomeDirectory();
    
    [self.view addSubview:self.textField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.frame = CGRectMake(0, 0, 300, 50);
    btn.center = CGPointMake(self.view.center.x, self.view.center.y - 190);
    [btn setTitle:@"启动贷款SDK(local)" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(launch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.layer.borderColor = [UIColor blueColor].CGColor;
    btn1.layer.borderWidth = 1.0;
    btn1.frame = CGRectMake(0, 0, 300, 50);
    btn1.center = CGPointMake(self.view.center.x, self.view.center.y - 120);
    [btn1 setTitle:@"启动贷款SDK(remote)" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(launchRemote) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.layer.borderColor = [UIColor blueColor].CGColor;
    btn2.layer.borderWidth = 1.0;
    btn2.frame = CGRectMake(0, 0, 300, 50);
    btn2.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
    [btn2 setTitle:@"测试TalkData" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(testTalkData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn3.layer.borderColor = [UIColor blueColor].CGColor;
    btn3.layer.borderWidth = 1.0;
    btn3.frame = CGRectMake(0, 0, 300, 50);
    btn3.center = CGPointMake(self.view.center.x, self.view.center.y + 10);
    [btn3 setTitle:@"扫一扫" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(clickScanQRCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn4.layer.borderColor = [UIColor blueColor].CGColor;
    btn4.layer.borderWidth = 1.0;
    btn4.frame = CGRectMake(0, 0, 300, 50);
    btn4.center = CGPointMake(self.view.center.x, self.view.center.y + 80);
    [btn4 setTitle:@"新的扫一扫" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(clickScanResult:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];

}


- (void)clickScanQRCode:(UIButton *)btn {
    [[QHLoanDoor share] launchScanLink:@{@"BarColor":@"#d8e6ff",@"BarTitleColor":@"#ff6600"} title:@"链接扫描列表" environment:QHLoanDoorEnvironment_stg successBlock:^{
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)clickScanResult:(UIButton *)btn {
    [[QHLoanDoor share] launchScanResult:@{@"BarColor":@"#d8e6ff",@"BarTitleColor":@"#ff6600"} environment:QHLoanDoorEnvironment_stg successBlock:^{
        
    } failBlock:^(NSError *error) {
        
    }];
}

- (void)launch{
    
    //    QHLoanDoor *door = [QHLoanDoor share];
    //
    //    door.startPage = @"www/index.html";
    //
    [[QHLoanDoor share] launchDoor:@{@"BarColor":@"#d8e6ff",@"BarTitleColor":@"#ff6600"}
                      startPageUrl:@"www/index.html"
                       environment:QHLoanDoorEnvironment_stg
                      successBlock:^{
                          //启动成功
                      } failBlock:^(NSError *error) {
                          //启动失败
                      }];
}

- (void)launchRemote{
    
    ///Library/WebServer/Documents/
    
    //sudo apachectl start
    
    NSString *str = @"https://test-p2pp-loan-stg.pingan.com.cn/loan/page/demo/index.html";
    if (_textField.text  && ([_textField.text hasPrefix:@"http://"] || [_textField.text hasPrefix:@"https://"])) {
        str = _textField.text;
    }
    //    QHLoanDoor *door = [QHLoanDoor share];
    //    door.startPage = str;
    
    [[QHLoanDoor share] launchDoor:@{@"BarColor":@"#d8e6ff",@"BarTitleColor":@"#ff6600"}
                      startPageUrl:str
                       environment:QHLoanDoorEnvironment_stg
                      successBlock:^{
                          //启动成功
                      } failBlock:^(NSError *error) {
                          //启动失败
                      }];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        _textField.center = CGPointMake(self.view.center.x, self.view.center.y -260);
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.placeholder = @"请输入网址";
        _textField.text = @"https://test-p2pp-loan-stg.pingan.com.cn/loan/page/demo/index.html";
    }
    return _textField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
