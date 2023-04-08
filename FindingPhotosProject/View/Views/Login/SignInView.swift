//
//  SignInView.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/30.
//

import SnapKit

class SignInView: UIView {
    
    // MARK: - Properties
    
    lazy var isAlreadyExistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.isHidden = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .superLightGrey
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
    
    private lazy var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .tabButtondarkGrey
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var emailTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.tabButtonlightGrey.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(emailTextField)
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력하세요."
        textField.layer.borderColor = .none
        textField.font = UIFont.systemFont(ofSize: 13)
        return textField
    }()
    
    lazy var emailTextFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTitleLabel ,emailTextFieldView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    
    private lazy var passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = .tabButtondarkGrey
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.tabButtonlightGrey.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(passwordTextField)
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력하세요."
        textField.layer.borderColor = .none
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var passwordTextFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordTitleLabel ,passwordTextFieldView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .tabButtondarkGrey
        return label
    }()
    
    private lazy var nameTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.tabButtonlightGrey.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(nameTextField)
        return view
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력하세요."
        textField.layer.borderColor = .none
        textField.font = UIFont.systemFont(ofSize: 13)
        return textField
    }()
    
    lazy var nameTextFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTitleLabel ,nameTextFieldView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var allTextFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextFieldStackView ,passwordTextFieldStackView, nameTextFieldStackView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .tabButtondarkGrey
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()
    
    lazy var openPrivacyPolicyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("개인정보 처리방침", for: .normal)
        button.setTitleColor(UIColor.systemGray3, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.backgroundColor = .none
        return button
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayout()
        setValue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers


}

extension SignInView: LayoutProtocol {
    
    func setValue() {
        self.backgroundColor = .white
    }
    
    func setSubViews() {
        [isAlreadyExistLabel, profileImageView, plusIconImageView, imagePickerButton, allTextFieldStackView, signInButton, openPrivacyPolicyButton]
            .forEach { self.addSubview($0) }
    }

    func setLayout() {
        
        isAlreadyExistLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(80)
        }

        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(isAlreadyExistLabel.snp.bottom).offset(30)
            make.width.height.equalTo(150)
        }
        plusIconImageView.snp.makeConstraints { make in
            make.right.equalTo(profileImageView.snp.right).inset(7)
            make.bottom.equalTo(profileImageView.snp.bottom).inset(7)
            make.top.equalTo(profileImageView.snp.top).inset(113)
            make.width.height.equalTo(30)
        }

        
        imagePickerButton.snp.makeConstraints { make in
            make.center.equalTo(profileImageView.snp.center)
            make.width.height.equalTo(130)
        }
        [emailTextFieldView, passwordTextFieldView, nameTextFieldView].forEach { $0.snp.makeConstraints
            { make in
                make.width.equalTo(270)
                make.height.equalTo(40)
            }
        }
        
        [emailTextField, passwordTextField, nameTextField].forEach { $0.snp.makeConstraints
            { make in
                make.height.equalToSuperview()
                make.width.equalToSuperview().inset(10)
                make.centerX.equalToSuperview()
            }
        }
        [nameTitleLabel, emailTitleLabel, passwordTitleLabel].forEach { $0.snp.makeConstraints
            { make in
                make.width.equalTo(60)
                make.height.equalTo(40)
            }
        }
        allTextFieldStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
        }
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(allTextFieldStackView.snp.bottom).offset(30)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
        openPrivacyPolicyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(signInButton.snp.bottom).offset(8)
            make.width.equalTo(120)
            make.height.equalTo(20)
        }
    }
    
    
}
