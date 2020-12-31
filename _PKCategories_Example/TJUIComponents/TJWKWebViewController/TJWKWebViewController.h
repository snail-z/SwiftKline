//
//  TJWKWebViewController.h
//  TJWKWebViewController
//
//  Created by zhanghao on 2020/12/29.
//  Copyright © 2020 gren-beans. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

/// WKWebView加载样式
typedef NS_ENUM(NSUInteger, TJWKWebLoadingStyle) {
    /// 进度条样式
    TJWKWebLoadingStyleProgress = 0,
    /// 活动指示器样式
    TJWKWebLoadingStyleIndicator,
    /// 无加载样式
    TJWKWebLoadingStyleNone
};

@class TJWKWebViewJavascriptBrige;

@interface TJWKWebViewController : UIViewController <WKNavigationDelegate>

/** 设置需要加载的本地资源文件路径 */
@property(nonatomic, copy, nullable) NSString *pathOfResources;

/** 设置需要加载的URL */
@property(nonatomic, copy, nullable) NSString *urlString;

/** 是否对URL进行特殊字符编码，默认NO */
@property(nonatomic, assign) BOOL urlEncodeAllowed;

/** 设置请求超时时间，默认60s */
@property(nonatomic, assign) NSTimeInterval timeoutInterval;

/** 设置缓存策略，默认为NSURLRequestUseProtocolCachePolicy */
@property(nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

/** 设置加载等待样式，默认进度条样式 */
@property(nonatomic, assign) TJWKWebLoadingStyle loadingStyle;

/** 设置加载样式颜色，默认系统蓝色 */
@property(nonatomic, nullable) UIColor *loadingTintColor;

/** 加载内容时是否转动状态栏菊花，默认YES */
@property(nonatomic, assign) BOOL loadingIndicatorVisible;

/** 加载失败时是否显示错误提示，默认YES */
@property(nonatomic, assign) BOOL showLoadFailed;

/** 是否显示页面提供来源，默认NO */
@property(nonatomic, assign) BOOL pageSourceDisplayed;

/** 是否允许页面内左右划导航手势，默认YES */
@property(nonatomic, assign) BOOL allowsBackForwardGestures;

/** 是否启用日志，默认NO */
@property(nonatomic, assign) BOOL debugLogEnabled;

/** 当前页面的WebView */
@property(nonatomic, readonly) WKWebView *wkWebView;

/** 原生与js交互桥接
 *  注意：若block块内需要使用self，务必使用'__weak typeof(self) weakSelf = self'来避免循环引用 */
@property(nonatomic, readonly) TJWKWebViewJavascriptBrige *wkJavascriptBrige;

/** 重新加载页面数据 */
- (BOOL)reloadWKWebview;

@end

typedef void (^TJWKResponseCallback)(_Nullable id responseBody);
typedef void (^TJWKHandler)(_Nullable id response, NSError * _Nullable error);

@interface TJWKWebViewJavascriptBrige : NSObject

/** js调用原生方法 (注册原生事件供 JavaScript 调用)
 *
 * @param methodName 约定的交互方法名称
 * @param handler 回调信息，responseBody 是 JavaScript 传给原生的数据
 * @param decisionActionPolicyAllowed 是否允许WKWebView继续内部跳转
 * 注意：responseBody 允许接收类型包括NSNumber/NSString/NSDate/NSArray/NSDictionary/NSNull.
 */
- (void)registerNative:(NSString *)methodName handler:(TJWKResponseCallback)handler decisionActionPolicyAllowed:(BOOL)decisionActionPolicyAllowed;

/** js调用原生方法，默认不允许WKWebView内部跳转 */
- (void)registerNative:(NSString *)methodName handler:(TJWKResponseCallback)handler;

/** 删除供 JavaScript 调用的指定原生事件 */
- (void)removeNativeHandler:(NSString*)methodName;

/** 删除供 JavaScript 调用的所有原生事件 */
- (void)removeNativehandlers;

/** 原生调用js方法 (该方法应在WebView加载完成后调用)
 *
 * @param methodName 约定的交互方法名称
 * @param data 传给js的参数信息 (允许类型包括NSNumber/NSString/NSArray/NSDictionary.)
 * @param handler 回调信息
 */
- (void)callJavascript:(NSString *)methodName data:(nullable id)data handler:(nullable TJWKHandler)handler;

/** 原生调用js方法，无参数传递 (该方法应在WebView加载完成后调用) */
- (void)callJavascript:(NSString *)methodName handler:(nullable TJWKHandler)handler;

@end

NS_ASSUME_NONNULL_END
