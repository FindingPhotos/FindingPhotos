//
//  SignInViewModel.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/04/01.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

class SignInViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let selectedImage = BehaviorRelay<UIImage?>(value: nil)
        let emailTextFieldText = BehaviorRelay<String>(value: "")
        let passwordTextFieldText = BehaviorRelay<String>(value: "")
        let nameTextFieldText = BehaviorRelay<String>(value: "")
        let signInButtonTapped = PublishRelay<Void>()
        let privacyPolicyButtonTapped = PublishRelay<Void>()
    }
    
    struct Output {
        let isValid: Observable<Bool>
        let profileImage: PublishRelay<UIImage?>
        let isSignInSuccess: Observable<Bool>
        let isAlreadyExistText: Observable<String?>
        let resetResultLabel: Observable<Bool>
    }
    
    let input = Input()
    lazy var output = transform(input: input)
    
    func transform(input: Input) -> Output {
        
        let profileImage = PublishRelay<UIImage?>()

        let isValid = Observable.combineLatest(input.emailTextFieldText, input.passwordTextFieldText, input.nameTextFieldText)
            .map { email, password, name in
                return !email.isEmpty && email.contains("@") && email.contains (".") && password.count > 5 && !name.isEmpty
            }
        
        input.selectedImage
            .withUnretained(self)
            .subscribe { viewModel, image in
                guard let image else { return }
                profileImage.accept(image)
            }
            .disposed(by: disposeBag)
            
        
        // 2️⃣ 목표: 회원가입 버튼이 눌리면 모듈화된 회원가입 서비스로 회원가입 실행
        // 문제상황: output으로 isSignInSuccess을 받아, 이를 이용해 유저모델을 만드는 처리 따로 실행해야 함.
        // 해결방안: 유저모델이 필요가 없어짐.
        let isAlreadyExistText = input.signInButtonTapped
            .withLatestFrom(Observable.combineLatest(input.emailTextFieldText, input.passwordTextFieldText, input.nameTextFieldText, input.selectedImage))
            .flatMap { email, password, name, image in
                AuthManager.shared.signIn(email: email, password: password, name: name, image: image)
            }
            .share()

       let isSignInSuccess = isAlreadyExistText.map { string in
            if string == nil {
                return true
            } else {
                return false
            }
        }
            
        let resetResultLabel = Observable.combineLatest(input.emailTextFieldText, input.nameTextFieldText, input.passwordTextFieldText)
            .map { _ in return true}

        return Output(isValid: isValid, profileImage: profileImage, isSignInSuccess: isSignInSuccess, isAlreadyExistText: isAlreadyExistText, resetResultLabel: resetResultLabel)
    }
    
}
