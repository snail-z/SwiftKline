//
//  TJWKWebViewController.m
//  TJWKWebViewController
//
//  Created by zhanghao on 2020/12/29.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import "TJWKWebViewController.h"

#pragma mark - TJWKWebReloadView // 重新加载提示视图

@interface TJWKWebReloadView : UIView

@property(nonatomic, strong) UIColor *tintColor;

@end

@implementation TJWKWebReloadView

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGFloat triangleLengthOfSide = 20;
    CGFloat arcLineWidth = 3;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat halfWidth = self.frame.size.width / 2;
    CGFloat halfHeight = self.frame.size.height / 2;
    
    CGPoint initialPoint = CGPointMake(halfWidth, halfHeight);
    CGFloat radius = halfWidth - triangleLengthOfSide / 2;
    CGContextAddArc(context, initialPoint.x, initialPoint.y, radius, 0, 3 * M_PI_2, 0);
    CGContextSetStrokeColorWithColor(context, _tintColor.CGColor);
    CGContextSetLineWidth(context, arcLineWidth);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPoint triangle[3];
    triangle[0] = CGPointMake(halfWidth, 0);
    triangle[1] = CGPointMake(halfWidth, triangleLengthOfSide);
    CGFloat dif = pow(triangleLengthOfSide, 2) - pow((triangleLengthOfSide / 2), 2);
    triangle[2] = CGPointMake(halfWidth + sqrt(dif), triangleLengthOfSide / 2);
    CGContextAddLines(context, triangle, 3);
    CGContextSetFillColorWithColor(context, _tintColor.CGColor);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
}

@end

#pragma mark - TJWKWebFailedView // 加载失败提示

@interface TJWKWebFailedView : UIView

@property(nonatomic, readonly) UILabel *messageLabel;
@property(nonatomic, readonly) UIView *reloadView;
@property(nonatomic, copy) void (^didTappedReload)(TJWKWebFailedView *failedView);

@end

@implementation TJWKWebFailedView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.0;
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = [UIColor colorWithRed:155/255.f green:155/255.f blue:155/255.f alpha:1];
        [self addSubview:_messageLabel];
        
        _reloadView = [[TJWKWebReloadView alloc] init];
        _reloadView.userInteractionEnabled = YES;
        _reloadView.backgroundColor = [UIColor clearColor];
        _reloadView.tintColor = [UIColor colorWithRed:195/255.f green:195/255.f blue:195/255.f alpha:1];
        [self addSubview:_reloadView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
        [_reloadView addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapRecognizer:(UITapGestureRecognizer *)g {
    if (self.didTappedReload) {
        self.didTappedReload(self);
    }
}

- (void)setError:(NSError *)error class:(TJWKWebViewController *)webVC {
    if (!error) return;
    NSString *description = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    NSString *URLString = [error.userInfo objectForKey:@"NSErrorFailingURLStringKey"];
    NSString *toastText = @"", *message = @"";
    switch (error.code) {
        case -1009: {
            toastText = @"似乎已断开与互联网的连接";
            message = @"您可以在设备的设置面板中启用移动网络或Wi-Fi网络！";
        } break;
        case -1001: {
            toastText = @"请求超时";
            message = [NSString stringWithFormat:@"%@ \"%@\"", description, URLString];
        } break;
        case -1002: {
            toastText = @"无法打开指定的地址";
            message = [NSString stringWithFormat:@"%@ \"%@\"", description, URLString];
        } break;
        case -1003: {
            toastText = @"无法连接服务器";
            message = [NSString stringWithFormat:@"%@ \n \"%@\"", description, URLString];
        } break;
        case -1202: {
            toastText = @"此服务器证书无效";
            message = [NSString stringWithFormat:@"Code=%@ %@ \n \"%@\"", @(error.code), description, URLString];
        } break;
        default: {
            toastText = @"页面加载失败";
            message = [NSString stringWithFormat:@"Code=%@ %@ \n \"%@\"", @(error.code), description, URLString];
        } break;
    }
    
    NSString *text = [NSString stringWithFormat:@"%@\n%@", toastText, message];
    if (webVC.debugLogEnabled) {
        NSLog(@"** %@ ** \n%@", NSStringFromClass(webVC.class), text);
    }
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attriText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    CGFloat fontSize1 = 14, fontSize2 = 12;
    if ([UIScreen mainScreen].bounds.size.width <= 320) {
        fontSize1 = 12; fontSize2 = 10;
    }
    [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize1] range:[text rangeOfString:toastText]];
    [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize2] range:[text rangeOfString:message]];
    
    CGFloat maxWidth = self.bounds.size.width - 30;
    CGSize size = [attriText boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine context:nil].size;
    size.width = maxWidth;
    CGRect frame = _messageLabel.frame;
    frame.origin.x = 15;
    frame.size = size;
    _messageLabel.frame = frame;
    _messageLabel.attributedText = attriText;
    
    [self layoutUpdates];
}

- (void)layoutUpdates {
    CGFloat centerOffset = (UIScreen.mainScreen.bounds.size.height > 736) ? 75 : 50;
    _messageLabel.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 - centerOffset);
    CGSize imageSize = CGSizeMake(85, 85);
    _reloadView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    _reloadView.center = CGPointMake(self.bounds.size.width / 2, _messageLabel.frame.origin.y - imageSize.height / 2 - 5);
}

@end

#pragma mark - TJWKWebLoadingView // 加载指示器

@interface TJWKWebLoadingView : UIView

@property (nonatomic, strong, readonly) UILabel *messageLabel;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign, readonly) BOOL isLoading;

@end

@implementation TJWKWebLoadingView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.0;
        
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.text = @"正在加载";
        [self addSubview:_messageLabel];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [self addSubview:_indicatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat centerOffset = (UIScreen.mainScreen.bounds.size.height > 736) ? 40 : 30;
    CGSize size = CGSizeMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _messageLabel.frame = CGRectMake(0, 0, 100, 35);
    _messageLabel.center = CGPointMake(size.width, size.height - centerOffset);
    _indicatorView.center = CGPointMake(size.width, _messageLabel.frame.origin.y - _indicatorView.bounds.size.height / 2);
}

- (void)startLoading {
    if (self.isLoading) return;
    _isLoading = YES;
    [_indicatorView startAnimating];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
    } completion:NULL];
}

- (void)stopLoading {
    if (!_isLoading) return;
    _isLoading = NO;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self->_indicatorView stopAnimating];
        [self removeFromSuperview];
    }];
}

@end

#pragma mark - TJWKWebProgressView // 加载进度条

@interface TJWKWebProgressView : UIView

@property (nonatomic, readonly) UIProgressView *progressView;

@end

@implementation TJWKWebProgressView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.0;
        _progressView = [[UIProgressView alloc] initWithFrame:frame];
        _progressView.tintColor = [UIColor clearColor];
        _progressView.trackTintColor = [UIColor clearColor];
        [self addSubview:_progressView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressView.frame = self.bounds;
    self.progressView.transform = CGAffineTransformMakeScale(1, 2.0);
}

- (void)beginProgress {
    self.alpha = 1.0;
    [UIView animateWithDuration:0.1 animations:^{
        [self.progressView setProgress:0.001 animated:YES];
    } completion:NULL];
}

- (void)setProgress:(float)progress {
    if (progress > 0 && self.alpha < 1) self.alpha = 1;
    [UIView animateWithDuration:0.1 animations:^{
        [self.progressView setProgress:progress animated:YES];
    } completion:^(BOOL finished) {
        if (progress < 1.0) {
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 1.0;
            } completion:NULL];
        } else {
            [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0 animated:NO];
            }];
        }
    }];
}

@end

#pragma mark - TJWKWebViewJavascriptBrige // js交互桥接

@interface _TJScriptMessageWrapper : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak, readonly) id<WKScriptMessageHandler> scriptHandler;

@end

@implementation _TJScriptMessageWrapper

- (instancetype)initWithHandler:(id<WKScriptMessageHandler>)handler {
    if (self = [super init]) {
        _scriptHandler = handler;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptHandler userContentController:userContentController didReceiveScriptMessage:message];
}

@end

static NSString *const kMethodBodyCallbackKey = @"methodBodyCallbackKey";
static NSString *const kMethodDecidedAllowKey = @"methodDecidedAllowKey";

typedef NSMutableDictionary<NSString *, id> TJMessagesDictionary;

@interface TJWKWebViewJavascriptBrige () <WKScriptMessageHandler>

@property (nonatomic, copy, readonly) NSString *messageName;
@property (nonatomic, weak, readonly) WKWebView *wkWebView;
@property (nonatomic, strong) _TJScriptMessageWrapper *scriptWrapper;
@property (nonatomic, strong) NSMutableDictionary<NSString *, TJMessagesDictionary *> *messagesBlocks;

@end

@implementation TJWKWebViewJavascriptBrige

+ (instancetype)bridgeForWebView:(WKWebView *)webView {
    return [[self alloc] initWithWKWebView:webView];
}

- (instancetype)initWithWKWebView:(WKWebView *)webView {
    if (self = [super init]) {
        if (!webView.configuration.userContentController) {
            WKUserContentController *userContentController = [[WKUserContentController alloc] init];
            webView.configuration.userContentController = userContentController;
        }
        _wkWebView = webView;
    }
    return self;
}

- (NSMutableDictionary<NSString *,TJMessagesDictionary *> *)messagesBlocks {
    if (!_messagesBlocks) {
        _messagesBlocks = [NSMutableDictionary dictionary];
    }
    return _messagesBlocks;
}

- (_TJScriptMessageWrapper *)scriptWrapper {
    if (!_scriptWrapper) {
        _scriptWrapper = [[_TJScriptMessageWrapper alloc] initWithHandler:self];
    }
    return _scriptWrapper;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSString *messageKey = message.name;
    if (!messageKey) return;
    _messageName = messageKey;
    TJMessagesDictionary *messages = [self.messagesBlocks objectForKey:messageKey];
    TJWKResponseCallback callback = [messages objectForKey:kMethodBodyCallbackKey];
    if (callback) {
        callback(message.body);
    }
}

- (void)registerNative:(NSString *)methodName handler:(TJWKResponseCallback)handler decisionActionPolicyAllowed:(BOOL)decisionActionPolicyAllowed {
    NSParameterAssert(methodName);
    if (handler) {
        [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:methodName];
        [self.wkWebView.configuration.userContentController addScriptMessageHandler:self.scriptWrapper name:methodName];
        TJMessagesDictionary *messages = [NSMutableDictionary dictionary];
        messages[kMethodDecidedAllowKey] = [@(decisionActionPolicyAllowed) copy];
        messages[kMethodBodyCallbackKey] = [handler copy];
        [self.messagesBlocks setObject:messages forKey:methodName];
    }
}

- (void)registerNative:(NSString *)methodName handler:(TJWKResponseCallback)handler {
    return [self registerNative:methodName handler:handler decisionActionPolicyAllowed:NO];
}

- (void)removeNativeHandler:(NSString *)methodName {
    if ([self.messagesBlocks.allKeys containsObject:methodName]) {
        [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:methodName];
        [self.messagesBlocks removeObjectForKey:methodName];
    }
}

- (void)removeNativehandlers {
    NSArray<NSString *> *allKeys = self.messagesBlocks.allKeys;
    for (NSString *aKey in allKeys) {
        [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:aKey];
    }
    [self.messagesBlocks removeAllObjects];
}

- (void)callJavascript:(NSString *)methodName data:(id)data handler:(TJWKHandler)handler {
    NSParameterAssert(methodName);
    if ([data isKindOfClass:[NSNumber class]] ||
        [data isKindOfClass:[NSString class]] || !data) {
    } else if ([data isKindOfClass:[NSArray class]] ||
               [data isKindOfClass:[NSDictionary class]]) {
        if ([NSJSONSerialization isValidJSONObject:data]) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
            data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    } else { return; }
    NSString *javaScriptString = [NSString stringWithFormat:@"%@('%@')", methodName, data];
    [self.wkWebView evaluateJavaScript:javaScriptString completionHandler:handler];
}

- (void)callJavascript:(NSString *)methodName handler:(TJWKHandler)handler {
    [self.wkWebView evaluateJavaScript:methodName completionHandler:handler];
}

- (void)dealloc {
    [self removeNativehandlers];
}

@end

#pragma mark - TJWKWebViewController

@interface TJWKWebViewController () <WKUIDelegate>

@property(nonatomic, strong) TJWKWebViewJavascriptBrige *wkJavascriptBrige;
@property(nonatomic, strong) UILabel *wkSourceLabel;
@property(nonatomic, strong) WKWebView *wkWebView;
@property(nonatomic, strong) TJWKWebProgressView *wkProgressView;
@property(nonatomic, strong) TJWKWebLoadingView *wkLoadingView;
@property(nonatomic, strong) TJWKWebFailedView *wkFailedView;
@property(nonatomic, assign) BOOL wkLoadFinished;

@end

@implementation TJWKWebViewController

- (instancetype)init {
    self = [super init];
    _debugLogEnabled = NO;
    _timeoutInterval = 60;
    _cachePolicy = NSURLRequestUseProtocolCachePolicy;
    _pageSourceDisplayed = NO;
    _allowsBackForwardGestures = YES;
    _loadingStyle = TJWKWebLoadingStyleProgress;
    _loadingTintColor = [UIColor colorWithRed:0 green:122 / 255. blue:255 / 255. alpha:1];
    _showLoadFailed = YES;
    _loadingIndicatorVisible = YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];
    [self reloadWKWebview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _addObservers];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self _removeObservers];
}

- (BOOL)reloadWKWebview {
    BOOL isCanLoaded = NO;
    if (self.urlString) {
        isCanLoaded = [self _loadRequest];
    } else if (self.pathOfResources) {
        isCanLoaded = [self _loadResources];
    } else {
        [self debugLog:@"Please set a load item, urlString or pathOfResources!!!"];
    }
    
    if (isCanLoaded) {
        switch (self.loadingStyle) {
            case TJWKWebLoadingStyleIndicator:
                [self.wkLoadingView startLoading];
                break;
            case TJWKWebLoadingStyleProgress:
                [self.wkProgressView beginProgress];
                break;
            default: break;
        }
    }
    return isCanLoaded;
}

- (BOOL)_loadRequest {
    NSString *urlString = self.urlString;
    if (self.urlEncodeAllowed) {
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    }
    
    NSURL *loadURL = [NSURL URLWithString:urlString];
    if (!loadURL) {
        [self debugLog:@"Check if the URL is legal!!!\n URLString = %@", urlString];
        return NO;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:loadURL cachePolicy:self.cachePolicy timeoutInterval:self.timeoutInterval];
    [self.wkWebView loadRequest:request];
    return YES;
}

- (BOOL)_loadResources {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).lastObject;
    path = [path stringByAppendingString:self.pathOfResources];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return NO;
    
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    if ([self.wkWebView respondsToSelector:@selector(loadFileURL:allowingReadAccessToURL:)]) {
        [self.wkWebView loadFileURL:baseURL allowingReadAccessToURL:baseURL];
    } else {
        NSError *error = nil;
        NSString *appHtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (error || !appHtml) {
            [self debugLog:@"%@\n%@", NSStringFromSelector(_cmd), error];
            return NO;
        }
        [self.wkWebView loadHTMLString:appHtml baseURL:baseURL];
    }
    return YES;
}

- (TJWKWebViewJavascriptBrige *)wkJavascriptBrige {
    if (!_wkJavascriptBrige) {
        _wkJavascriptBrige = [TJWKWebViewJavascriptBrige bridgeForWebView:self.wkWebView];
    }
    return _wkJavascriptBrige;
}

- (TJWKWebFailedView *)wkFailedView {
    if (!_wkFailedView) {
        _wkFailedView = [[TJWKWebFailedView alloc] initWithFrame:self.wkWebView.bounds];
        _wkFailedView.reloadView.tintColor = [self.loadingTintColor colorWithAlphaComponent:0.7];
        _wkFailedView.messageLabel.textColor = self.loadingTintColor;
        [self.wkWebView addSubview:_wkFailedView];
    }
    return _wkFailedView;
}

- (TJWKWebLoadingView *)wkLoadingView {
    if (!_wkLoadingView) {
        _wkLoadingView = [[TJWKWebLoadingView alloc] initWithFrame:self.wkWebView.bounds];
        _wkLoadingView.indicatorView.color = self.loadingTintColor;
        _wkLoadingView.messageLabel.textColor = self.loadingTintColor;
        [self.wkWebView addSubview:_wkLoadingView];
    }
    return _wkLoadingView;
}

- (TJWKWebProgressView *)wkProgressView {
    if (!_wkProgressView) {
        _wkProgressView = [[TJWKWebProgressView alloc] initWithFrame:CGRectMake(0, 0, self.wkWebView.bounds.size.width, 2)];
        _wkProgressView.progressView.tintColor = self.loadingTintColor;
        [self.wkWebView addSubview:_wkProgressView];
    }
    return _wkProgressView;
}

- (UILabel *)wkSourceLabel {
    if (!_wkSourceLabel) {
        _wkSourceLabel = [[UILabel alloc] init];
        _wkSourceLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
        _wkSourceLabel.alpha = 0;
        _wkSourceLabel.textAlignment = NSTextAlignmentCenter;
        _wkSourceLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.75];
        _wkSourceLabel.font = [UIFont systemFontOfSize:12];
        [self.wkWebView addSubview:_wkSourceLabel];
    }
    return _wkSourceLabel;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.javaScriptEnabled = YES;
        preferences.minimumFontSize = 10.f;
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = preferences;
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        configuration.userContentController = userContentController;
        configuration.allowsInlineMediaPlayback = YES;
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _wkWebView.scrollView.scrollEnabled = YES;
        _wkWebView.opaque = NO; // 防止切换背景色闪动问题，但这可能会导致某些页面有穿透效果，视情况而定
    }
    return _wkWebView;
}

- (void)setAllowsBackForwardGestures:(BOOL)allowsBackForwardGestures {
    _allowsBackForwardGestures = allowsBackForwardGestures;
    if (@available(iOS 9.0, *)) {
        self.wkWebView.allowsBackForwardNavigationGestures = allowsBackForwardGestures;
    } else {
        self.wkWebView.allowsBackForwardNavigationGestures = NO;
    }
}

#pragma mark - Observers

- (void)_addObservers {
    for (NSString *aKey in [self keyPaths]) {
        [self.wkWebView addObserver:self forKeyPath:aKey options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)_removeObservers {
    for (NSString *aKey in [self keyPaths]) {
        [self.wkWebView removeObserver:self forKeyPath:aKey context:nil];
    }
}

- (NSArray<NSString *> *)keyPaths {
    return @[@"title",
             @"estimatedProgress",
             @"canGoBack",
             @"canGoForward",
             @"scrollView.contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.wkWebView != object) {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    if ([keyPath isEqualToString:@"scrollView.contentOffset"]) {
        if (self.pageSourceDisplayed) {
            CGFloat const limit = 40;
            if (self.wkWebView.scrollView.contentOffset.y < -fabs(limit)) {
                self.wkSourceLabel.alpha = fabs(fabs(self.wkWebView.scrollView.contentOffset.y) - fabs(limit)) / 60;
            } else {
                self.wkSourceLabel.alpha = 0;
            }
        }
    }
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat _progress = self.wkWebView.estimatedProgress;
        if (_progress < 1.0) {
            [self setLoadingProgress:_progress];
        }
    }
}

- (void)setLoadingProgress:(CGFloat)progress {
    switch (self.loadingStyle) {
        case TJWKWebLoadingStyleIndicator: {
            if (progress < 1.0) {
                [self.wkLoadingView startLoading];
            } else {
                [self.wkLoadingView stopLoading];
            }
        } break;
        case TJWKWebLoadingStyleProgress:
            [self.wkProgressView setProgress:progress];
            break;
        default: break;
    }
    
    if (self.loadingIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = (progress < 1.0);
    }
}

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    // 开始加载
    [self hideFailedView];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    // 当内容开始返回时调用
    if (self.loadingStyle == TJWKWebLoadingStyleIndicator) {
        [self.wkLoadingView stopLoading];
    }
    [self hideFailedView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 加载完成
    self.wkLoadFinished = YES;
    [self hideFailedView];
    [self setLoadingProgress:1];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // 开始加载数据发生错误时调用
    [self debugLog:@"ErrorCode=%@\n%@", @(error.code), error.userInfo];
    [self showFailedViewWithError:error];
    [self setLoadingProgress:1];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // 加载期间发生错误时调用
    [self debugLog:@"ErrorCode=%@\n%@", @(error.code), error.userInfo];
    if (error.code == NSURLErrorCancelled) {
        [self setLoadingProgress:1];
    } else if (error.code == 204) {
        // 修复加载视频204错误(手动忽略)
        [self setLoadingProgress:1];
    } else {
        [self setLoadingProgress:1];
        [self showFailedViewWithError:error];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 在发送请求之前，决定是否跳转
    NSString *URLString = navigationAction.request.URL.absoluteString;
    [self debugLog:@"Decide policy navigation URL : %@", URLString];
    
    if (self.pageSourceDisplayed) {
        NSString *host = navigationAction.request.URL.host;
        self.wkSourceLabel.text = [NSString stringWithFormat:@"此网页由 %@ 提供", host];
    }
    
    if (self.wkJavascriptBrige.messageName) {
        TJMessagesDictionary *messages = self.wkJavascriptBrige.messagesBlocks[self.wkJavascriptBrige.messageName];
        if (![messages[kMethodDecidedAllowKey] boolValue]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    NSString *scheme = navigationAction.request.URL.scheme.lowercaseString;
    if ([scheme hasPrefix:@"sms"] || [scheme hasPrefix:@"tel"] || [scheme hasPrefix:@"mailto"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self handleURL:URLString];
        return;
    }
    
    if ([navigationAction.request.URL.host isEqualToString:@"itunes.apple.com"] && [URLString rangeOfString:@"id"].location != NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self handleItunesURL:URLString];
        return;
    }
    
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    // 在收到响应后，决定是否跳转 和发送请求前是否跳转配套使用
    if (decisionHandler) decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    // 授权验证
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self debugLog:@"[%@] URL is: %@", NSStringFromSelector(_cmd), self.wkWebView.URL.absoluteString];
    // 服务器重定向时调用
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self debugLog:@"[%@] URL is: %@", NSStringFromSelector(_cmd), self.wkWebView.URL.absoluteString];
    // 9.0之后方法，web内容处理中断时会触发
}

#pragma mark - Tools

- (void)showFailedViewWithError:(NSError *)error {
    if (!self.showLoadFailed || self.wkLoadFinished) return;
    
    self.wkFailedView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.wkFailedView.alpha = 1;
    } completion:NULL];
    
    [self.wkFailedView setError:error class:self];
    
    __weak typeof(self) weakSelf = self;
    self.wkFailedView.didTappedReload = ^(TJWKWebFailedView *failedView) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [failedView removeFromSuperview];
        if ([strongSelf.wkWebView canGoBack]) {
            [strongSelf.wkWebView reloadFromOrigin];
        } else {
            [strongSelf reloadWKWebview];
        }
    };
}

- (void)hideFailedView {
    if (!_wkFailedView) return;
    [_wkFailedView removeFromSuperview];
    _wkFailedView = nil;
}

- (void)handleURL:(NSString *)URLString {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:URLString];
    if ([application canOpenURL:URL]) {
        NSDictionary *opts = [NSDictionary dictionary];
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [application openURL:URL options:opts completionHandler:NULL];
            }
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [application openURL:URL];
#pragma clang diagnostic pop
        }
    }
}

- (void)handleItunesURL:(NSString *)URLString {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *message = [NSString stringWithFormat:@"即将离开%@\n打开\"App Store\"", appName];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *allowAction = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleURL:URLString];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:allowAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)debugLog:(id)description, ... {
    if (!description || !self.debugLogEnabled) return;
    id message = description;
    va_list args;
    va_start(args, description);
    if ([description isKindOfClass:[NSString class]]) {
        message = [[NSString alloc] initWithFormat:description locale:[NSLocale currentLocale] arguments:args];
    }
    va_end(args);
    NSLog(@"** %@ ** %@", NSStringFromClass(self.class), message);
}

#pragma mark - dealloc

- (void)dealloc {
    if (_wkJavascriptBrige) {
        [self debugLog:@"Javascript Removed: %@", self.wkJavascriptBrige.messagesBlocks.allKeys];
    }
    [self.wkWebView stopLoading];
    [self debugLog:@"-dealloc✈️"];
}

@end
