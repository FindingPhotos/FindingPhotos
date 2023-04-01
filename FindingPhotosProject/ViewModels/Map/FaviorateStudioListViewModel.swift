//
//  FaviorateStudioListViewModel.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/31.
//

import UIKit

import RxSwift
import RxCocoa

final class FaviorateStudioListViewModel: ViewModelType {
    
    struct Input {
        
    }
    struct Output {
        
    }
    let input = Input()
    lazy var output = transform(input: input)
    var disposeBag = DisposeBag()
    // MARK: - transform
    func transform(input: Input) -> Output {
        return Output()
    }
}
