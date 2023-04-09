//
//  ModifyProfileView.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/28.
//

import UIKit

final class ModifyProfileView: UIView {
    
    // MARK: - Properties
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray3
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        return imageView
    }()
    
    private lazy var plusIconImageView: UIImageView = {
        let image = UIImage(named: "addButton")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .tabButtondarkGrey
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .none
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var imagePickerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        return button
    }()
    
    private lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .tabButtondarkGrey
        return label
    }()
    
    private lazy var nameTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.tabButtonlightGrey.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
//        textField.text = "바꿀 닉네임 입력"
        textField.layer.borderColor = .none
        textField.font = UIFont.systemFont(ofSize: 13)
        return textField
    }()
    
    lazy var modifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .tabButtondarkGrey
        button.setTitle("수정하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()
    
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


extension ModifyProfileView: LayoutProtocol {
    func setSubViews() {
        [profileImageView, plusIconImageView, imagePickerButton, nameTitleLabel, nameTextFieldView, nameTextField, modifyButton].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nameTitleLabel.snp.centerY).offset(-50)
            make.width.height.equalTo(150)
        }
        plusIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.right.equalTo(profileImageView.snp.right).inset(7)
            make.bottom.equalTo(profileImageView.snp.bottom).inset(7)
            make.top.equalTo(profileImageView.snp.top).inset(113)
        }
        imagePickerButton.snp.makeConstraints { make in
            make.width.height.equalTo(130)
            make.center.equalTo(profileImageView.snp.center)
        }
        nameTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(40)
            make.width.equalTo(50)
            make.centerY.equalToSuperview()
        }
        nameTextFieldView.snp.makeConstraints { make in
            make.left.equalTo(nameTitleLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(40)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextFieldView.snp.top)
            make.bottom.equalTo(nameTextFieldView.snp.bottom)
            make.width.equalTo(nameTextFieldView.snp.width).inset(12)
            make.centerX.equalTo(nameTextFieldView.snp.centerX)
        }
        modifyButton.snp.makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.centerY).offset(50)
            make.left.right.equalToSuperview().inset(140)
            make.height.equalTo(35)
        }
        
    }
    
    
}
