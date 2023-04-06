//
//  SignInViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/30.
//

import SnapKit
import RxSwift
import RxCocoa
import RxRelay

final class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    private let signInView = SignInView()
    private let viewModel = SignInViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        setSubViews()
        setLayout()
        bindWithoutViewModel()
        bindViewModel()
        bindImagePicker()
    }

    
    // MARK: - helpers


    
    private func bindWithoutViewModel() {
        signInView.openPrivacyPolicyButton.rx.tap
            .withUnretained(self)
            .subscribe { viewController, event in
                viewController.openSFSafari(url: "https://thread-pike-aca.notion.site/Personal-Information-Policy-17a0bfbcb74446f8b6a166bd289e33d4")
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        // input
        signInView.signInButton.rx.tap
            .bind(to: viewModel.input.signInButtonTapped)
            .disposed(by: disposeBag)

        signInView.openPrivacyPolicyButton.rx.tap
            .bind(to: viewModel.input.privacyPolicyButtonTapped)
            .disposed(by: disposeBag)
        
        signInView.emailTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.input.emailTextFieldText)
            .disposed(by: disposeBag)
        signInView.passwordTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.input.passwordTextFieldText)
            .disposed(by: disposeBag)
        signInView.nameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.input.nameTextFieldText)
            .disposed(by: disposeBag)
        
        // output
        viewModel.output.isValid
            .map { $0 ? 1 : 0.3 }
            .bind(to: signInView.signInButton.rx.alpha)
            .disposed(by: disposeBag)
        
        viewModel.output.isValid
            .bind(to: signInView.signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
    
        viewModel.output.profileImage
            .bind(to: signInView.profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        // 실패했을 때 알람처리 해줘야 함...
        viewModel.output.isSignInSuccess
            .bind(to: signInView.isAlreadyExistLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.isAlreadyExistText
            .bind(to: signInView.isAlreadyExistLabel.rx.text)
            .disposed(by: disposeBag)

        
    }
    
    private func bindImagePicker() {
        signInView.imagePickerButton.rx.tap
            .flatMapLatest({ [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                    picker.view.tintColor = .black
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
            })
            .map { info in
                return info[.editedImage] as? UIImage
            }
            .bind(to: viewModel.input.selectedImage)
            .disposed(by: disposeBag)
    }
    
}

extension SignInViewController: LayoutProtocol {
    func setValue() {
        navigationController?.navigationItem.title = "회원가입"
        view.backgroundColor = .white
    }
    func setSubViews() {
        view.addSubview(signInView)
    }
    
    func setLayout() {
        signInView.snp.makeConstraints { make in
            make.width.equalTo(375)
            make.height.equalTo(660)
            make.centerX.centerY.equalToSuperview()
        }
    }
}
