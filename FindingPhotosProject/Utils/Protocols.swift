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

@objc protocol LayoutProtocol: AnyObject {
    @objc optional func setValue()
    func addSubViews()
    func layout()
}
