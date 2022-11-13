//
//  SceneDelegate.swift
//  MyiOSCalculator
//
//  Created by davisatwell on 11/7/22

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView().environmentObject(GlobalEnvironment())

        if let scene = scene as? UIWindowScene {
            let windowFrame = UIWindow(windowScene: scene)
            windowFrame.rootViewController = UIHostingController(rootView: contentView)
            self.window = windowFrame
            windowFrame.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

