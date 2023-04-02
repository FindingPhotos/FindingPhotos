//
//  ProfileView.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/26.
//

import SnapKit

final class ProfileView: UIView {
    
    // MARK: - Properties
    
    private lazy var nameLabel: UILabel = {
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
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tabButtonlightGrey
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
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


extension ProfileView: LayoutProtocol {
    func setSubViews() {
        [profileImageView, nameLabel, profileSetButton].forEach { self.addSubview($0) }
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
        
    }
    
    
}
