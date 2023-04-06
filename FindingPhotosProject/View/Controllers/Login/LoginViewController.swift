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
        bindWithoutViewModel()
        bindViewModel()
        setSubViews()
        setLayout()
    }
    
    // MARK: - helpers
    
    private func bindWithoutViewModel() {
        loginView.signInButton.rx.tap
            .withUnretained(self)
            .subscribe { viewController, event in
                viewController.navigationController?.pushViewController(SignInViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        loginView.forgotPasswordButton.rx.tap
            .withUnretained(self)
            .subscribe { viewController, event in
                viewController.navigationController?.pushViewController(ResetPasswordViewController(), animated: true)
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
        
        viewModel.output.isLoginSuccess
//            .withUnretained(self)
            .map { $0 ? "로그인되었습니다✅" : "아이디와 비밀번호를 확인해주세요❗️"}
            .bind(to: loginView.loginCheckedLabel.rx.text)
            .disposed(by: disposeBag)
            
        viewModel.output.isLoginSuccess
            .bind(to: loginView.loginCheckedLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        loginView.loginButton.rx.tap
            .bind(to: viewModel.input.logInButtonTapped)
            .disposed(by: disposeBag)
        
        loginView.signWithAnonymousButton.rx.tap
            .bind(to: viewModel.input.logInAnonymouslyButtonTapped)
            .disposed(by: disposeBag)
    }
    
    
}

extension LoginViewController: LayoutProtocol {
    func setSubViews() {
        self.view.addSubview(loginView)
    }
    
    func setLayout() {
        loginView.snp.makeConstraints { make in
            make.width.equalTo(375)
            make.height.equalTo(660)
            make.centerX.centerY.equalToSuperview()
        }
    }
}
