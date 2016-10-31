//
//  AllViewController.m
//  LMDemo
//
//  Created by xsy on 16/9/6.
//  Copyright © 2016年 pxl. All rights reserved.
//

#import "AllViewController.h"
#import "WebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>

@interface AllViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, assign) OCJSTpye type;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@end

@implementation AllViewController

- (instancetype)initWithOCJSType:(OCJSTpye)type title:(NSString *)title{
    self = [super init];
    if (self) {
//        self.type = type;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"1", @"2", @"2", @"1"];
    NSMutableArray *arr1 = [NSMutableArray array];
    for (NSString *str in arr) {
        if ([arr1 indexOfObject:str] == NSNotFound) {
            [arr1 addObject:str];
        }
    }
    NSLog(@"arr1  ==  %@",arr1);
    
    switch (self.type) {
        case OCJSTpyeJavaScriptCore:
            [self ocjsJavaScriptCore];
            break;
            
        case OCJSTpyeAgreement:
            [self ocjsAgreement];
            break;
            
        case OCJSTpyeWebViewJavaScriptBridge:
            [self ocjsWebViewJavaScriptBridge];
            break;
            
        case OCJSTpyeWKWebView:
            [self ocjsWKWebView];
            break;
            
        default:
            break;
    }
    
    
    self.allViewBlock(@"哈哈哈");
    
    
}

#pragma mark - JavaScriptCore
/**  JavaScriptCore*/
- (void)ocjsJavaScriptCore {
    //JSContext对象   直接调用js代码
    [self jsContent];
    
    
    //注入模型
//    [self jsProtocol];
    
}

//直接调用
- (void)jsContent {
    //创建一个JSContext对象
    self.context = [[JSContext alloc] init];
    
    //jscontext 可以直接执行js代码
    [self.context evaluateScript:@"var squareFunc = function(value) { return value + 100 }"];
    
    //计算
    JSValue *square = [self.context evaluateScript:@"squareFunc(10)"];
    NSLog(@"square ==  %@",square.toNumber);
    
    //通过下标的方式获取到方法
    JSValue *squareFunc = self.context[@"squareFunc"];
    JSValue *value = [squareFunc callWithArguments:@[@"20"]];
    NSLog(@"value ==  %@",value.toNumber);
}

//注入模型
- (void)jsProtocol {
    [self.view addSubview:self.webView];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //注入模型
    JsObjCModel *model = [[JsObjCModel alloc] init];
    self.context[@"OCModel"] = model;


//    self.webView stringByEvaluatingJavaScriptFromString:<#(nonnull NSString *)#>
    
    
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息  ==  %@",exceptionValue);
    };
    
    
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scalesPageToFit = YES;
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"HelloWorld" withExtension:@"html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        _webView.delegate = self;
    }
    return _webView;
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //获取请求的绝对路径
    NSString *requestStr = [request URL].absoluteString;
    if ([requestStr hasPrefix:@"符合要求的字符串"]) {
        //js需要执行的操作
        //并禁止网页跳转
        return NO;
    }
    return YES;
}


#pragma mark - Agreement
/**  Agreement*/
- (void)ocjsAgreement {
    
    
    
    
    
    
    
}

#pragma mark - WebViewJavaScriptBridge
/**  WebViewJavaScriptBridge*/
- (void)ocjsWebViewJavaScriptBridge {
    
    //开启日志，方便调试
    [WebViewJavascriptBridge enableLogging];
    
    //给webView建立JS与OC的沟通桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    //设置代理
    [self.bridge setWebViewDelegate:self];
    
    
    // JS主动调用OC方法
    // JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
    // JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
    // OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
    [self.bridge registerHandler:@"JSFromObjc" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback) {
            responseCallback(@"OC返回给JS数据");
        }
    }];
    
    
    
    
}

#pragma mark - WKWebView
/**  WKWebView*/
- (void)ocjsWKWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //设置偏好设置
    configuration.preferences = [[WKPreferences alloc] init];
    configuration.preferences.minimumFontSize = 10;
    configuration.preferences.javaScriptEnabled = YES;
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    //创建WKUserContentController对象
    WKUserContentController *userContent = [[WKUserContentController alloc] init];
    //注入js对象名称OCModel（我们可以在WKScriptMessageHandler代理中接收到）
    [userContent addScriptMessageHandler:self name:@"OCModel"];
    //添加交互对象
    configuration.userContentController = userContent;
    
    
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *jsString = @"function sayHello(){ \
        alert('jack11')   \
        }                   \
        sayHello()";
        [self.wkWebView evaluateJavaScript:jsString completionHandler:^(id item, NSError * _Nullable error) {
        
        }];
    });
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"OCModel"]) {
        //打印传过来的参数，支持NSNumber, NSString, NSDate, NSArray, NSDictionary等类型
        NSLog(@"messageBody  ==  %@",message.body);
    }
}

#pragma mark - WKUIDelegate
// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
}

#pragma mark - WKNavigationDelegate
// 请求开始前，会先调用这个代理方法
// 与UIWebView的shouldStartLoadWithRequest代理方法作用是一样的
// 请求的时候先判断能不能跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyCancel);//不允许web内跳转
    decisionHandler(WKNavigationActionPolicyAllow);//允许web内跳转
}

// 在响应完成时，会回调此方法
// 如果上面代理设为不允许跳转，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
}

//导航完成时会回调（页面载入完成）
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    });
    
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
