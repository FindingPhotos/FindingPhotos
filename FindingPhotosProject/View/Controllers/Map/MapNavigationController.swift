//
//  MapNavigationController.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/26.
//

import UIKit

final class MapNavigationController: UINavigationController {
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        navigationBar.isHidden = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationItem.title = "근처 사진관 찾기"
        navigationItem.titleView?.tintColor = .systemRed
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
