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

#pragma mark -- Action
- (void)authorization
{
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        
        //一个控制器，用于管理创建的授权请求
        ASAuthorizationController *ac = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
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
        /**
                        
         */
        NSLog(@"user = %@, state = %@, authorizedScopes = %@, authorizationCode = %@, identityToken = %@, email = %@, fullName = %@, realUserStatus = %ld", credential.user, credential.state, credential.authorizedScopes, credential.authorizationCode, credential.identityToken, credential.email, credential.fullName, (long)credential.realUserStatus);
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        ASPasswordCredential *password = authorization.credential;
        NSLog(@"user = %@, password = %@", password.user, password.password);
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
API_AVAILABLE(ios(13.0)) //回调失败
{
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

#pragma mark -- 配置UI
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
}


@end
