//
//  SettingView.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/30.
//

import SnapKit

class SettingView: UIView {
    
    // MARK: - Properties
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "익명으로 로그인되었습니다."
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var profileSetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("프로필 수정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.tabButtondarkGrey
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tabButtonlightGrey
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .none
        return button
    }()
    
    lazy var signoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .none
        return button
    }()
    
    private lazy var underBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .tabButtonlightGrey
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var profileView = UIView()
    private lazy var logoutView = UIView()
    
    // MARK: - Lifecycles
    
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

extension SettingView: LayoutProtocol {
    func setSubViews() {
        
        [profileImageView, nameLabel, profileSetButton].forEach { profileView.addSubview($0) }
        [logoutButton, signoutButton].forEach { logoutView.addSubview($0) }
        [profileView, logoutView, underBarView, tableView].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(20)
            make.centerY.equalToSuperview()
            
        }
        profileSetButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(85)
            make.height.equalTo(30)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        signoutButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        underBarView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(underBarView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(300)
        }
        logoutView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
            
        }
    }
    
    
    
}
