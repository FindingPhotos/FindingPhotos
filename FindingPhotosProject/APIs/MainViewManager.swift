//
//  MainViewManager.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/31.
//

import Foundation
import FirebaseCore
import FirebaseAuth

class MainViewManager {
    
    static let shared = MainViewManager()
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    private init() {
        FirebaseApp.configure()
        registerAuthStateDidChangeEvent()
    }
    
//    deinit {
//        NotificationCenter.removeObserver(self, forKeyPath: Notification.Name.AuthStateDidChange.rawValue)
//    }
    
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        checkLoginIn()
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkLoginIn),
                                               name: .AuthStateDidChange,
                                               object: nil)
    }
        
    @objc private func checkLoginIn() {
        
        if let user = Auth.auth().currentUser {
            setTapBarController()
        } else {
            setLoginViewController()
        }
    }
    
    
    private func setTapBarController() {
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
        
        rootViewController = tabBarVC
    }
    
    private func setLoginViewController() {
        let loginViewController = UINavigationController(rootViewController: LoginViewController())
        rootViewController = loginViewController
    }
}


