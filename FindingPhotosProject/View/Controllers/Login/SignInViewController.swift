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
        bindWithoutViewModel()
        bindViewModel()
        bindImagePicker()
    }
    override func loadView() {
        view = signInView
    }
    
    // MARK: - helpers

    func setValue() {
        navigationController?.navigationItem.title = "회원가입"
    }
    
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
    
        // 실패했을 때 알람처리 해줘야 함...
        viewModel.output.isSignInSuccess
            .subscribe()
            .disposed(by: disposeBag)
  
        
        
            // isSignInSuccess가 true 이면~ 이런식으로 조건절을 넣는건 안되고
            // 애초에 output의 observable을 Observable<Void> 와 같이 이벤트처럼 처리해서 받아와야 할까?
        
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

