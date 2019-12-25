//
//  ViewController.m
//  SignInWithAppleDemo
//
//  Created by 贺文杰 on 2019/12/11.
//  Copyright © 2019 贺文杰. All rights reserved.
//

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>

/**<屏幕宽度*/
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

/**<屏幕高度*/
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)viewWillLayoutSubviews
{
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            NSLog(@"UIUserInterfaceStyleLight");
        }else if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
            NSLog(@"UIUserInterfaceStyleDark");
        }else{
            NSLog(@"UIUserInterfaceStyleUnspecified");
        }
    } else {

    }
}

- (id)jwtDecodeWithJwtString:(NSString *)jwtStr index:(NSInteger)index{
    NSArray *segments = [jwtStr componentsSeparatedByString:@"."];
    NSString *base64String = [segments objectAtIndex:index];
    int requiredLength = (int)(4 *ceil((float)[base64String length]/4.0));
    int nbrPaddings = requiredLength - (int)[base64String length];
    if(nbrPaddings > 0){
        NSString * pading = [[NSString string] stringByPaddingToLength:nbrPaddings withString:@"=" startingAtIndex:0];
        base64String = [base64String stringByAppendingString:pading];
    }
    base64String = [base64String stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    base64String = [base64String stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodeString = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = @{};
    if (decodeString) {
        jsonDict = [NSJSONSerialization JSONObjectWithData:[decodeString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    }
    return jsonDict;
}

#pragma mark -- Notification
- (void)signInWithAppleChange:(NSNotification *)object
{
    NSLog(@"userInfo = %@", object.userInfo);
}

#pragma mark -- Action
- (void)authorization
{
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        ASAuthorizationPasswordProvider *passwordProvider = [ASAuthorizationPasswordProvider new];
        
        NSMutableArray *mtbAry = [NSMutableArray new];
        if (appleIDProvider) {
            ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
            request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
            [mtbAry addObject:request];
        }
    
        if (passwordProvider) { //获取KeyChain中的登录信息 
            ASAuthorizationPasswordRequest *passwordRequest = [passwordProvider createRequest];
            [mtbAry addObject:passwordRequest];
        }
        
         
        //一个控制器，用于管理创建的授权请求
        ASAuthorizationController *ac = [[ASAuthorizationController alloc] initWithAuthorizationRequests:mtbAry];
        ac.delegate = self;
        ac.presentationContextProvider = self;
        [ac performRequests];
    } else {
        
    }
}

#pragma mark -- ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization
API_AVAILABLE(ios(13.0)) //回调完成
{
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        /*
            user:苹果用户唯一标识符,该值在同一开发者账号下的所有App下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来
            identityToken:用于传给开发者后台服务器，然后开发者服务器向苹果的身份验证服务器验证本次授权登录请求数据的有效性和真实性，如果验证成功，可以根据userIdentifier判断账号是否存在
            fullName:苹果用户信息,包括全名、邮箱等
            realUserStatus:用于判断当前登录的苹果账号是否是一个真实用户
         */
        
        NSString *state = credential.state;
        NSString *userID = credential.user;
        NSPersonNameComponents *fullName = credential.fullName;
        NSString *email = credential.email;
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding]; //苹果授权的JWT凭证
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        NSArray *ary = [identityToken componentsSeparatedByString:@"."];
        for (NSInteger i = 0; i < ary.count; i++) {
            //根据apple返回的凭证，解码
            NSLog(@"strstr = %@", [self jwtDecodeWithJwtString:identityToken index:i]);
            
            /*
                kid是密钥id
                alg是密钥算法 RS256是(RSA256+SHA256)
                
                identityToken有效期是10分钟
                iss标识是苹果签发的
                aud是接收者的bundle id
                sub是用户的唯一标识
             */
        }

        NSLog(@"state: %@", state);
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        ASPasswordCredential *password = authorization.credential;
        NSLog(@"user = %@, password = %@", password.user, password.password);
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
API_AVAILABLE(ios(13.0)) //回调失败
{
    switch (error.code) {
        case ASAuthorizationErrorUnknown: //1000
            NSLog(@"授权失败未知原因");
            break;
        case ASAuthorizationErrorCanceled: //1001
            NSLog(@"用户取消了授权请求");
            break;
        case ASAuthorizationErrorInvalidResponse: //1002
            NSLog(@"授权请求响应无效");
            break;
        case ASAuthorizationErrorNotHandled: //1003
            NSLog(@"未能处理授权请求");
            break;
        case ASAuthorizationErrorFailed: //1004
            NSLog(@"授权请求失败");
            break;
        default:
            break;
    }
    NSLog(@"error = %@", error);
}

#pragma mark -- ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
API_AVAILABLE(ios(13.0)) //展示视图位置
{
    for (id win in [UIApplication sharedApplication].windows) {
        if ([win isKindOfClass:[UIWindow class]]) {
            return win;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark -- 配置UI及其他
- (void)configUI 
{
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *button = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleBlack];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH - (50 * 2), 50);
        button.center = self.view.center;
        [button addTarget:self action:@selector(authorization) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    } else {
        
    }
    [self addNotification];
}

- (void)addNotification
{
    if (@available(iOS 13.0, *)) {
        //以通知的方式监听苹果账号是否发生了变化，以便做相应的处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInWithAppleChange:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    } else {
        
    }
}


@end
