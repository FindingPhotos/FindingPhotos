//
//  ResetPasswordViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/04/06.
//

import SnapKit
import RxSwift
import RxCocoa

final class ResetPasswordViewController: UIViewController {
    
    // MARK: - Properties
    
    private let resetPasswordView = ResetPasswordView()
    private let disposeBag = DisposeBag()
    private var viewModel = ResetPasswordViewModel()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        setSubViews()
        setLayout()
        bindViewModel()
    }
    
    // MARK: - Helpers
    
    func bindViewModel() {
        resetPasswordView.emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.input.textFieldText)
            .disposed(by: disposeBag)
        
        resetPasswordView.resetButton.rx.tap
            .bind(to: viewModel.input.resetButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.output.resetErrorText
            .bind(to: resetPasswordView.resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.isErrorOccured
            .bind(to: resetPasswordView.resultLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.isEmailValid
            .debug("isEmailValid")
            .map { $0 ? 1 : 0.3}
            .bind(to: resetPasswordView.resetButton.rx.alpha)
            .disposed(by: disposeBag)
    }
    
}

extension ResetPasswordViewController: LayoutProtocol {
    func setValue() {
        navigationItem.title = "비밀번호 재설정"
        view.backgroundColor = .white
    }
    
    func setSubViews() {
        view.addSubview(resetPasswordView)
    }
    
    func setLayout() {
        resetPasswordView.snp.makeConstraints { make in
            make.width.equalTo(375)
            make.height.equalTo(660)
            make.centerX.centerY.equalToSuperview()
        }
    }
}
