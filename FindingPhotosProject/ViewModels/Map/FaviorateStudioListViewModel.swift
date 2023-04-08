//
//  FaviorateStudioListViewModel.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/31.
//

import UIKit

import RealmSwift

import RxSwift
import RxCocoa
import RxRealm

final class FaviorateStudioListViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear = PublishRelay<Bool>()
        let likeButtonTapped = PublishRelay<Int>()
    }
    struct Output {
        let photoStudios: BehaviorRelay<[PhotoStudio]>
    }
    let input = Input()
    lazy var output = transform(input: input)
    var disposeBag = DisposeBag()
    // MARK: - transform
    func transform(input: Input) -> Output {
        let realm = try! Realm()
        let savedData = realm.objects(PhotoStudio.self)
        
        let photoStudios = BehaviorRelay<[PhotoStudio]>(value: savedData.toArray())
        
        input.likeButtonTapped
            .flatMap { row in
                try! realm.write {
                    realm.delete(savedData[row])
                }
                return Observable.array(from: savedData)
            }
            .bind(to: photoStudios)
            .disposed(by: disposeBag)
            
            
        return Output(photoStudios: photoStudios)
    }
}
