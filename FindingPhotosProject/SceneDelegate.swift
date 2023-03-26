//
//  SceneDelegate.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)

        let tabBarVC = UITabBarController()
        
        let vc1 = UINavigationController(rootViewController: MapViewController())
        let vc2 = UINavigationController(rootViewController: PhotoViewController())
        let vc3 = UINavigationController(rootViewController: SettingViewController())

        tabBarVC.setViewControllers([vc1, vc2, vc3], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .white
        tabBarVC.tabBar.tintColor = UIColor.tabButtonlightGrey
        
        guard let items = tabBarVC.tabBar.items else { return }
        
        items[0].image = UIImage(systemName: "map.fill")
        items[0].selectedImage = UIImage(systemName: "map.fill")
        items[1].image = UIImage(systemName: "photo.fill")
        items[1].selectedImage = UIImage(systemName: "photo.fill")
        items[2].image = UIImage(systemName: "person.circle.fill")
        items[2].selectedImage = UIImage(systemName: "person.circle.fill")

        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }
}

