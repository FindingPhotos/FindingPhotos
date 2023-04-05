//
//  ModifyProfileViewModel.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/29.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa


final class ModifyProfileViewModel: ViewModelType {
    
    struct Input {
        let textFieldText = BehaviorRelay<String?>(value: nil)
        let selectedImage = BehaviorRelay<UIImage?>(value: nil)
        let ModifyButtonTapped = PublishRelay<Void>()
    }
    struct Output {
        let changedName: PublishRelay<String>
        let changedImage: PublishRelay<UIImage>
        let userInformation: Observable<UserModel?>
    }
    var disposeBag = DisposeBag()

    let input = Input()
    lazy var output = transform(input: input)
    
    func transform(input: Input) -> Output {
        
        let changedName = PublishRelay<String>()
        let changedImage = PublishRelay<UIImage>()
        
        let user = AuthManager.shared.getUserInformation()
        input.selectedImage
            .withUnretained(self)
            .subscribe { viewModel, image in
                guard let image else { return }
                changedImage.accept(image)
            }
            .disposed(by: disposeBag)

        input.ModifyButtonTapped
            .withLatestFrom(Observable.combineLatest(input.textFieldText, input.selectedImage))
            .map { changedName, changedImage in
                if let changedImage {
                    ImageUploaderToFirestorage.uploadImage(image: changedImage) { imageUrl in
                        AuthManager.shared.updateUserInformation(changedName: changedName, changedImageUrl: imageUrl)
                    }
                } else {
                    AuthManager.shared.updateUserInformation(changedName: changedName, changedImageUrl: nil)
                }
            }
            .asObservable()
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(changedName: changedName,
                      changedImage: changedImage,
                      userInformation: user)
        
    }
}
