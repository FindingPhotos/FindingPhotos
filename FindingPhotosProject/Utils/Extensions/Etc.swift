//
//  etc.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/04/02.
//

import UIKit

// MARK: - ViewModelBindable Extension
extension ViewModelBindable where Self: UIViewController {
    func bind(viewModel: ViewModel) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}


