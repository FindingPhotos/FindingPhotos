//
//  ResetPasswordViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/04/06.
//

import SnapKit
import RxSwift
import RxCocoa

final class ResetPasswordViewController: UIViewController {
    
    // MARK: - Properties
    
    private let resetPasswordView = ResetPasswordView()
    private let disposeBag = DisposeBag()
    private var viewModel = ResetPasswordViewModel()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        setSubViews()
        setLayout()
        bindViewModel()
    }
    
    // MARK: - Helpers
    

extension ResetPasswordViewController: LayoutProtocol {
    func setValue() {
        navigationItem.title = "비밀번호 재설정"
        view.backgroundColor = .white
    }
    
    func setSubViews() {
        view.addSubview(resetPasswordView)
    }
    
    func setLayout() {
        resetPasswordView.snp.makeConstraints { make in
            make.width.equalTo(375)
            make.height.equalTo(660)
            make.centerX.centerY.equalToSuperview()
        }
    }
}
