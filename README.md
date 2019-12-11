# SignInWithAppleDemo

## 介绍

1. 尊重隐私
> “通过 Apple 登录”的设计初衷就是为了让用户对自己的隐私感到放心。数据收集仅限于用户的姓名和电子邮件地址，而且即使用户更希望对自己的邮件地址保密，Apple 的私密电子邮件中继转发服务也能让他们收到相关电子邮件。Apple 不会跟踪用户与您 app 的交互情况。

2. 内置安全性
> 使用“通过 Apple 登录”的每个帐户均默认受到双重认证保护。在 Apple 设备上，用户会保持登录状态，并可以随时使用面容 ID 或触控 ID 重新进行身份验证。

3. 处处可用
> iOS、macOS、tvOS 和 watchOS 都原生支持“通过 Apple 登录”。此外，该功能可在任何浏览器中使用，这意味着您可以将它部署在您的网站上以及在其他平台上运行的 app 版本中。

4. 反欺诈
> “通过 Apple 登录”让您可以对新用户放心。它使用设备端机器学习功能和其他信息来提供一种能保障隐私的新信号，帮助您判断新用户是真人还是您可能需要再次检查的帐户。

## 配置环境

* xcode 11及以上
*  iOS 13及以上
* Mac OS 10.14.4及以后

## 工程配置

* TARGETS->Signing & Capabilities->Capability->Sign In With Apple
* TARGETS->Build Phases->Link Binary With Libraries->AuthenticationServices.framework
* TARGETS->General->Frameworks,Libraries,and Embedded Content->AuthenticationServices.framework->Do Not Embed

## 跨平台

* iOS、macOS、tvOS、watchOS、网页

## 实现流程

## API介绍

1. #import <AuthenticationServices/ASAuthorizationAppleIDButton.h> 按钮类

## 参考资料

* [介绍文档)](https://developer.apple.com/cn/sign-in-with-apple/get-started/)
* [API文档](https://developer.apple.com/documentation/authenticationservices?language=objc)
* [wwdc Sign In With Apple](https://developer.apple.com/videos/play/wwdc2019/706)
* [Sign In With Apple官方Swift源码](https://docs-assets.developer.apple.com/published/8f9ca51349/AddingTheSignInWithAppleFlowToYourApp.zip)
* [Human Interface Guidelines-设计规范](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/)
* [证书配置说明-英文](https://help.apple.com/developer-account/?lang=en#/devde676e696)

