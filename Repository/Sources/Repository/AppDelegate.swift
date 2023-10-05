//
//  AppDelegate.swift
//
//
//  Created by Илья Шаповалов on 30.09.2023.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import SwiftFP

public final class AppDelegate: NSObject, UIApplicationDelegate {
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            guard
                let user = user,
                let credential = self?.getCredential(from: user)
            else {
                return
            }
            
        }
        
        return true
    }
    
    public func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        return false
    }
}

private extension AppDelegate {
    func getCredential(from user: GIDGoogleUser) -> AuthCredential? {
        guard let idToken = user.idToken?.tokenString else {
            return nil
        }
        return GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.accessToken.tokenString
        )
    }
     
}
