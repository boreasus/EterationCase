//
//  SceneDelegate.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = UITabBarController()
        
        let firstViewController = UINavigationController(rootViewController: HomePageViewController())
        let secondViewController = UINavigationController(rootViewController: BasketPageViewController())
        let thirdViewController = UINavigationController(rootViewController: ThirdViewController())
        let fourthViewController = UINavigationController(rootViewController: FourViewController())

        firstViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: AssetStrings.home), selectedImage: nil)
        secondViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: AssetStrings.basket), selectedImage: nil)
        thirdViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: AssetStrings.star), selectedImage: nil)
        fourthViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: AssetStrings.person), selectedImage: nil)
        
        let standartInset = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        firstViewController.tabBarItem.imageInsets = standartInset
        secondViewController.tabBarItem.imageInsets = standartInset
        thirdViewController.tabBarItem.imageInsets = standartInset
        fourthViewController.tabBarItem.imageInsets = standartInset

        tabBarController.viewControllers = [firstViewController,
                                            secondViewController,
                                            thirdViewController,
                                            fourthViewController]
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBarController.tabBar.standardAppearance = appearance
        
        
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBasketBadge), name: NSNotification.Name(NotificationCenterStrings.basketUpdated), object: nil)
        updateBasketBadge()
    }
    
    @objc func updateBasketBadge() {
            let baseViewModel = BaseViewModel()
            let productCount = baseViewModel.fetchLocalProducts().count
            let tabBarController = window?.rootViewController as? UITabBarController
            tabBarController?.tabBar.items?[1].badgeValue = productCount > 0 ? "\(productCount)" : nil
        }

    func sceneDidDisconnect(_ scene: UIScene) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(NotificationCenterStrings.basketUpdated), object: nil)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

