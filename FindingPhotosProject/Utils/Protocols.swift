//
//  Protocols.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/26.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

protocol ViewModelBindable: AnyObject {
    associatedtype ViewModel: ViewModelType
    var disposeBag: DisposeBag { get set }
    var viewModel: ViewModel! { get set }
    
    func bindViewModel()
}

protocol CellModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

protocol CellModelBindable {
    associatedtype CellModelType
    var disposeBag: DisposeBag { get set }
    var cellModel: CellModelType! { get set }
    
    func bindCellModel()
}


@objc protocol LayoutProtocol: AnyObject {
    @objc optional func setValue()
    func setSubViews()
    func setLayout()
}
