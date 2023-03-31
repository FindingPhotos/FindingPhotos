//
//  LoginViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import SnapKit
import RxSwift
import RxRelay

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let loginView = LoginView()
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindButtons()
        bindViewModel()
    }
    
    override func loadView() {
        view = loginView
    }
    // MARK: - helpers
    
    private func bindButtons() {
        loginView.signInButton.rx.tap
            .withUnretained(self)
            .subscribe { viewController, event in
                viewController.navigationController?.pushViewController(SignInViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        loginView.openPrivacyPolicyButton.rx.tap
            .withUnretained(self)
            .subscribe { viewController, event in
                viewController.openSFSafari(url: "https://thread-pike-aca.notion.site/Personal-Information-Policy-17a0bfbcb74446f8b6a166bd289e33d4")
            }
            .disposed(by: disposeBag)
    }
    private func bindViewModel() {
        loginView.emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.input.emailTextFieldText)
            .disposed(by: disposeBag)
        
        loginView.passwordTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.input.passwordTextFieldText)
            .disposed(by: disposeBag)
        
        viewModel.output.isValid
            .map { $0 ? 1 : 0.3 }
            .bind(to: loginView.loginButton.rx.alpha)
            .disposed(by: disposeBag)
        
        viewModel.output.isValid
            .bind(to: loginView.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginView.loginButton.rx.tap
            .bind(to: viewModel.input.logInButtonTapped)
            .disposed(by: disposeBag)
        
        loginView.signWithAnonymousButton.rx.tap
            .bind(to: viewModel.input.logInAnonymouslyButtonTapped)
            .disposed(by: disposeBag)
    }
    
    
}

