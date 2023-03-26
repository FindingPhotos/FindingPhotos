//
//  LogoutView.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/26.
//

import SnapKit

final class LogoutView: UIView {
    
    // MARK: - Properties
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .none
        return button
    }()

    private lazy var signoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .none
        return button
    }()
    
    // MARK: - Lifecylces
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
}


extension LogoutView: LayoutProtocol {
    func setSubViews() {
        [logoutButton, signoutButton].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        logoutButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        signoutButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}
