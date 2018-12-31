//
//  AppDelegateExtentions.swift
//  iMusic
//
//  Created by New User on 12/30/18.
//  Copyright © 2018 sasan soroush. All rights reserved.
//
import UIKit
import GoogleSignIn
extension AppDelegate{
   
    func setupApp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        //        window?.rootViewController = UINavigationController(rootViewController: SignUpViewController())
        mainTabBarController = ESTabBarController()
        mainTabBarController.delegate = self
        mainTabBarController.title = "Irregularity"
        mainTabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        mainTabBarController.tabBar.backgroundImage = #imageLiteral(resourceName: "tabbar_bg_dark")
        mainTabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        mainTabBarController.didHijackHandler = {
            [weak mainTabBarController] tabbarController, viewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: nil)
                alertController.addAction(takePhotoAction)
                let selectFromAlbumAction = UIAlertAction(title: "Select from album", style: .default, handler: nil)
                alertController.addAction(selectFromAlbumAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                mainTabBarController?.present(alertController, animated: true, completion: nil)
            }
            
        }
        
        let v1 = HomeViewController()
        let v2 = HomeViewController()
        let v3 = HomeViewController()
        let v4 = HomeViewController()
        let v5 = HomeViewController()
        
        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Playlist", image: #imageLiteral(resourceName: "playlist"), selectedImage: #imageLiteral(resourceName: "playlist_1"))
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: #imageLiteral(resourceName: "download"), selectedImage: #imageLiteral(resourceName: "download"))
        v4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "News", image: #imageLiteral(resourceName: "news"), selectedImage: #imageLiteral(resourceName: "news_1"))
        v5.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        mainTabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        let navigationController_signedIn = UINavigationController(rootViewController: mainTabBarController)
        mainTabBarController.title = "Example"
        
        let navigationController_signedOut = UINavigationController(rootViewController: SignUpViewController())
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
             self.window?.rootViewController = navigationController_signedIn
        } else {
             self.window?.rootViewController = navigationController_signedOut
        }
       
    }
}
