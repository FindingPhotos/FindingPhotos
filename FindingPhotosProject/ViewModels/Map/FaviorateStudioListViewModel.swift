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
    }
    struct Output {
        let photoStudios: Observable<[PhotoStudio]>
    }
    let input = Input()
    lazy var output = transform(input: input)
    var disposeBag = DisposeBag()
    // MARK: - transform
    func transform(input: Input) -> Output {
        let realm = try! Realm()
        let savedData = realm.objects(PhotoStudio.self)
        let photoStudios = Observable.array(from: savedData)
        return Output(photoStudios: photoStudios)
    }
}
