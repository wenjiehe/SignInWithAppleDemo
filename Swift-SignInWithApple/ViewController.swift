//
//  ViewController.swift
//  Swift-SignInWithApple
//
//  Created by 贺文杰 on 2019/12/25.
//  Copyright © 2019 贺文杰. All rights reserved.
//

import UIKit
import AuthenticationServices

let kSCREEN_WIDTH = UIScreen.main.bounds.size.width
let kSCREEN_HEIGHT = UIScreen.main.bounds.size.height

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        performExistingAccountSetupFlows()
    }
    
    func initView(){
        let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        authorizationButton.frame = CGRect.init(x: 30, y: 300, width: kSCREEN_WIDTH - 60, height: 50)
        authorizationButton.addTarget(self, action: #selector(clickSignInWithAppleAction), for: .touchUpInside)
        self.view.addSubview(authorizationButton)
    }
    
    // MARK: -- Action
    @objc func clickSignInWithAppleAction(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

}

extension ViewController : ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("user = \(appleIDCredential.user),fullName = \(String(describing: appleIDCredential.fullName)),email = \(String(describing: appleIDCredential.email))")
        }else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            print("\(passwordCredential)")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

    }
}

extension ViewController : ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

