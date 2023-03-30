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
        let textFieldText = PublishRelay<String>()
        let selectedImage = PublishRelay<UIImage?>()
    }
    struct Output {
        let changedName: PublishRelay<String>
        let changedImage: PublishRelay<UIImage>
    }
    var disposeBag = DisposeBag()

    let input = Input()
    lazy var output = transform(input: input)
    
    func transform(input: Input) -> Output {
        
        let changedName = PublishRelay<String>()
        let changedImage = PublishRelay<UIImage>()
        
//        input.textFieldText
//            .withUnretained(self)
//            .subscribe { viewModel, text in
//                changedName.accept(text)
//            }
//            .disposed(by: disposeBag)
        
        let changedText = input.textFieldText
        
        input.selectedImage
            .withUnretained(self)
            .subscribe { viewModel, image in
                guard let image else {
                    // 선택된 이미지가 없을 떼 -> 아마 이미지피커를 키기만 하고 이미지를 선택하지 않았을 때 일텐데,
                    // 이 때 기존 유저모델에 이미지가 있다면 다시 그 이미지를, 아니면 아무 이미지도 없도록 만드는 코드 필요할 예정.
                    return
                }
                changedImage.accept(image)
            }
            .disposed(by: disposeBag)
        
        return Output(changedName: changedName,
                      changedImage: changedImage)
        
    }
    // 이후 기본 유저 모델값을 만들고 기본값으로 넣어주면 될듯
//    let changedUser: BehaviorRelay<UserModel> = BehaviorRelay(value: UserModel(name: "", profileImage: UIImage(named: "")))
    

    

    
    
    
    
}
