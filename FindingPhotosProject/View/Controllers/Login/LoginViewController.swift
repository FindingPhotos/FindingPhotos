//
//  LoginViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import SnapKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let loginView = LoginView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadView() {
        view = loginView
    }
    // MARK: - helpers
    
    
    
}

