//
//  ResetPasswordViewModel.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/04/06.
//

import RxSwift
import RxCocoa
import RxRelay

class ResetPasswordViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    let input = Input()
    lazy var output = transform(input: input)
    
    struct Input {
        let textFieldText = BehaviorRelay<String>(value: "")
        let resetButtonTapped = PublishSubject<Void>()
    }
    struct Output {
        let isEmailValid: Observable<Bool>
        let resetResultLabel: Observable<Bool>
        let resetFailureText: Driver<String?>
        let isErrorOccured:  Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let isEmailValid = input.textFieldText
            .map { !$0.isEmpty && $0.contains("@") && $0.contains (".") }
        
        let resetResultLabel = input.textFieldText
            .map { _ in return true}
        
        let resetFailureText = input.resetButtonTapped
            .withLatestFrom(input.textFieldText)
            .flatMap { email in
                AuthManager.shared.sendForgotPasswordEmail(email: email)
            }
            .asDriver(onErrorJustReturn: "")
            .debug("resetFailureText")
    
        let isErrorOccured = resetFailureText.map { error in
            if error == nil {
                return true
            } else {
                return false
            }
        }
            .asObservable()
        
        
        return Output(isEmailValid: isEmailValid, resetResultLabel: resetResultLabel, resetFailureText: resetFailureText, isErrorOccured: isErrorOccured)
    }
    
}
