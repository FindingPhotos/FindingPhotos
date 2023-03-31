//
//  SignInViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/30.
//

import SnapKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    let signInView = SignInView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func loadView() {
        view = signInView
    }
    
    // MARK: - helpers

    
}

