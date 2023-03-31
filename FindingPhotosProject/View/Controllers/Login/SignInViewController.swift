//
//  SignInViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/30.
//

import SnapKit

final class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    private let signInView = SignInView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func loadView() {
        view = signInView
    }
    
    // MARK: - helpers

    
}

