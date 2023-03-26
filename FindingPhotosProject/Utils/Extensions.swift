//
//  Extensions.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import UIKit

extension UIColor {
    // 나누기 255 할 필요 없음, alpha값 1로 고정
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
            }
    // 메인 색상 4가지
    static let tabButtonlightGrey = UIColor(red: 0.829, green: 0.819, blue: 0.819, alpha: 1)
    static let tabButtondarkGrey = UIColor(red: 0.287, green: 0.287, blue: 0.287, alpha: 1)
    static let darked = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
    static let buttonYellow = UIColor(red: 0.962, green: 0.837, blue: 0.393, alpha: 1)
}

extension ViewModelBindable where Self: UIViewController {
    func bind(viewModel: ViewModel) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
