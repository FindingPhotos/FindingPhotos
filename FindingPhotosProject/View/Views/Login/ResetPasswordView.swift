//
//  ResetPasswordView.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/04/06.
//

import SnapKit

final class ResetPasswordView: UIView {
    
    // MARK: - Properties
    
    private lazy var guideLabel: UILabel = {
        let label = UILabel()
        label.text = "가입하신 이메일을 입력하세요."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var emailTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.tabButtonlightGrey.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "email"
        textField.layer.borderColor = .none
        return textField
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비밀번호 리셋하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.tabButtondarkGrey
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.isHidden = true
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setValue()
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    
}

extension ResetPasswordView: LayoutProtocol {
    func setValue() {
//        self.backgroundColor = .white
    }
    
    func setSubViews() {
        [guideLabel, emailTextFieldView, resultLabel, resetButton].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        guideLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalToSuperview().inset(150)
        }
        emailTextFieldView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalTo(guideLabel.snp.bottom).offset(60)
            make.height.equalTo(40)
        }
        resultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(15)
        }
        resetButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(100)
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(40)
            make.height.equalTo(40)
        }
    }
    
    
    
}
