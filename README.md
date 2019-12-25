# SignInWithAppleDemo

## 介绍

1. 尊重隐私
> “通过 Apple 登录”的设计初衷就是为了让用户对自己的隐私感到放心。数据收集仅限于用户的姓名和电子邮件地址，而且即使用户更希望对自己的邮件地址保密，Apple 的私密电子邮件中继转发服务也能让他们收到相关电子邮件。Apple 不会跟踪用户与您 app 的交互情况。

2. 内置安全性
> 使用“通过 Apple 登录”的每个帐户均默认受到[双重认证保护](https://support.apple.com/en-us/HT204915)。在 Apple 设备上，用户会保持登录状态，并可以随时使用面容 ID 或触控 ID 重新进行身份验证。

3. 处处可用
> iOS、macOS、tvOS 和 watchOS 都原生支持“通过 Apple 登录”。此外，该功能可在任何浏览器中使用，这意味着您可以将它部署在您的网站上以及在其他平台上运行的 app 版本中。

4. 反欺诈
> “通过 Apple 登录”让您可以对新用户放心。它使用设备端机器学习功能和其他信息来提供一种能保障隐私的新信号，帮助您判断新用户是真人还是您可能需要再次检查的帐户。

## 配置环境

* xcode 11及以上
*  iOS 13及以上
* Mac OS 10.14.4及以后

## 证书配置

> 登录[apple开发官网](https://developer.apple.com),进入Certificates,Identifiers & Profiles,勾选Sign In With Apple,导出证书即可

## 工程配置

* TARGETS->Signing & Capabilities->Capability->Sign In With Apple
* TARGETS->Build Phases->Link Binary With Libraries->AuthenticationServices.framework
* TARGETS->General->Frameworks,Libraries,and Embedded Content->AuthenticationServices.framework->Do Not Embed

## 禁止使用情形

> 不得将“通过 Apple 登录”整合到存在以下情况的网站或 app 中：

* 违反任何法律或者不遵守法律要求；
* 为以下物品提供服务或交易：
  * 香烟或烟草制品；
  * 军火、武器或弹药；
  * 违禁药品或非法处方管制药品；
  * 给消费者带来安全风险的物品；
  * 打算用于从事非法活动的物品；
  * 色情作品；
  * 假冒或盗窃的物品；
* 主要提供或出售吸毒用具或者色情物品或服务；
* 基于种族、年龄、性别、性别认同、民族、宗教或性取向，而煽动仇恨、暴力或不容忍的情绪；
* 涉嫌任何形式的欺诈；
* 侵犯或违反他人知识产权、公开权或隐私权；
* 以虚假或侮辱性方式展示 Apple 或其产品。

> “通过 Apple 登录”API 只能用于允许用户自愿设置帐户并登录您的 app 或服务，不得另作他用。
Apple 保留随时以任何理由停用某个网站或 app 中的“通过 Apple 登录”功能的权利。


## 跨平台

* iOS、macOS、tvOS、watchOS、网页(app必须在App Store上架)

## 实现流程

1. 设置AuthenticationServices相关类进行布局，添加相应的授权处理
2. 获取授权码
3. 验证
4. 处理Sign In With Apple授权状态变化
5. 服务端拿到移动端获取到的JWT凭证去校验,[相关API](https://developer.apple.com/documentation/signinwithapplerestapi/generate_and_validate_tokens)

## 相关问题

1. 停止App使用Sign In With Apple的方式
> 设置->密码与安全性->使用您Apple ID的App->找到对应的App->停止使用Apple ID

2. 如何跟服务端交互，以及服务端如何和apple服务器交互
> 苹果开发官网创建privateKey,把私钥下载下来，并保存好，注意，私钥只能下载一次,Apple在服务器验证时候有两个接口，一个是获取[Public Key](https://developer.apple.com/documentation/signinwithapplerestapi/fetch_apple_s_public_key_for_verifying_token_signature),一个是验证[token](https://developer.apple.com/documentation/signinwithapplerestapi/generate_and_validate_tokens)。
根据Public Key对移动端获取到的[identityToken](http://www.ruanyifeng.com/blog/2018/07/json_web_token-tutorial.html)进行解码，以获取header及payload。


## API介绍

1.  ASAuthorizationAppleIDButton.h 按钮类
2. ASAuthorizationController 管理授权请求的控制器，并通过代理方法进行后续处理
3. ASAuthorizationAppleIDProvider 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
4. ASAuthorizationPasswordRequest 基于钥匙串凭证生成请求的一种机制

## 参考资料

* [介绍文档](https://developer.apple.com/cn/sign-in-with-apple/get-started/)
* [API文档](https://developer.apple.com/documentation/authenticationservices?language=objc)
* [wwdc Sign In With Apple](https://developer.apple.com/videos/play/wwdc2019/706)
* [Sign In With Apple官方Swift源码](https://docs-assets.developer.apple.com/published/8f9ca51349/AddingTheSignInWithAppleFlowToYourApp.zip)
* [Human Interface Guidelines-设计规范](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/)
* [证书配置说明-英文](https://help.apple.com/developer-account/?lang=en#/devde676e696)
* [证书配置及服务端校验-教程](https://developer.okta.com/blog/2019/06/04/what-the-heck-is-sign-in-with-apple)

