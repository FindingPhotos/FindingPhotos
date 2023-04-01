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
    }
    let input = Input()
    lazy var output = transform(input: input)
    
    func transform(input: Input) -> Output {
        
        let isValid = Observable.combineLatest(input.emailTextFieldText, input.passwordTextFieldText)
            .map { email, password in
                return !email.isEmpty && email.contains("@") && email.contains (".") && password.count > 5
            }
        // 1️⃣ 목표: 로그인버튼 탭 이벤트를 받으면 모듈화된 로그인 서비스 실행, 이후 성공 여부를 반환
        //         반환된 성공 여부로 로그인 성공/실패 레이블 text 변경
        // 현재 상황 : 모듈 메서드가 Observable<Void>를 반환하고, 이를 .subscribe()만 하면 성공 여부 반환 없을 시 로그인 실행 성공.
        // 문제 상황 : 모듈 메서드가 Observable<Bool>을 반환하고, 이를 output의 다른 값으로 bind 불가
        // 해결 : 탭 받은 후 처리한 데이터를 바로 변수로 반환 가능
        
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

        return Output(isValid: isValid, isLoginSuccess: isLoginSuccess)
    }
    
}
