//
//  LoginView.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/30.
//

import SnapKit

class LoginView: UIView {
    
    // MARK: - Properties

    private lazy var appLogo: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "appLogo")
            imageView.clipsToBounds = true
            return imageView
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
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.layer.borderColor = .none
        return textField
    }()
    
    private lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.tabButtonlightGrey.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.layer.borderColor = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var emailPasswordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    lazy var signWithAnonymousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가입하지 않고 둘러보기", for: .normal)
        button.setTitleColor(UIColor.tabButtonlightGrey, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .none
        button.layer.borderColor = UIColor.tabButtonlightGrey.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginButton, signWithAnonymousButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var loginCheckedLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디와 비밀번호를 확인해주세요❗️"
        label.textColor = .darkRed
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(UIColor.tabButtondarkGrey, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.backgroundColor = .none
        button.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비밀번호 재설정", for: .normal)
        button.setTitleColor(UIColor.tabButtonlightGrey, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .none
        button.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        return button
    }()
    
    private lazy var signInStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [signInButton, forgotPasswordButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 50
        return stackView
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



extension LoginView: LayoutProtocol {
    
    func setValue() {
        self.backgroundColor = .white
    }
    
    func setSubViews() {
        [appLogo, emailPasswordStackView, loginButtonStackView, loginCheckedLabel, signInStackView]
            .forEach { self.addSubview($0) }
    }

    func setLayout() {
        appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(120)
        }
        emailPasswordStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(70)
            make.top.equalTo(appLogo.snp.bottom).offset(40)
            make.height.equalTo(80)
        }
        loginCheckedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailPasswordStackView.snp.bottom).offset(10)
        }
        loginButtonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(120)
            make.top.equalTo(loginCheckedLabel.snp.bottom).offset(10)
            make.height.equalTo(80)
        }
        signInStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(loginButtonStackView.snp.bottom).offset(20)
        }
    }
}
