//
//  LoginViewModel.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/31.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

class LoginViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    struct Input {
        let emailTextFieldText = BehaviorRelay<String>(value: "")
        let passwordTextFieldText = BehaviorRelay<String>(value: "")
        let logInButtonTapped = PublishRelay<Void>()
        let logInAnonymouslyButtonTapped = PublishRelay<Void>()
    }
    struct Output {
        let isValid: Observable<Bool>
        let isLoginSuccess: Observable<Bool>
        let resetResultLabel: Observable<Bool>
    }
    let input = Input()
    lazy var output = transform(input: input)
    
    func transform(input: Input) -> Output {
        
        let isValid = Observable.combineLatest(input.emailTextFieldText, input.passwordTextFieldText)
            .map { email, password in
                return !email.isEmpty && email.contains("@") && email.contains (".") && password.count > 5
            }

        let isLoginSuccess = input.logInButtonTapped
            .withLatestFrom(Observable.combineLatest (input.emailTextFieldText, input.passwordTextFieldText))
            .flatMap { email, password in
                AuthManager.shared.logIn(email: email, password: password)
            }
            .share()
        
        input.logInAnonymouslyButtonTapped
            .flatMap({ _ in
                AuthManager.shared.signInWithAnonymous()
            })
            .subscribe()
            .disposed(by: disposeBag)
        
        let resetResultLabel = Observable.combineLatest(input.emailTextFieldText, input.passwordTextFieldText)
            .map { _ in return true}

        return Output(isValid: isValid, isLoginSuccess: isLoginSuccess, resetResultLabel: resetResultLabel)
    }
    
}
