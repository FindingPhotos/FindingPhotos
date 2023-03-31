//
//  LoginView.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/30.
//

import SnapKit

class LoginView: UIView {
    
    // MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FindingPhotos"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private lazy var emailTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.tabButtonlightGrey.cgColor
        view.layer.borderWidth = 2
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
    
    private lazy var passwordTextFieldView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.tabButtonlightGrey.cgColor
        view.layer.borderWidth = 2
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
        textField.layer.borderColor = .none
        return textField
    }()
    
    private lazy var emailPasswordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이메일로 로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.tabButtondarkGrey
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
//        button.snp.makeConstraints { make in
//            make.width.equalTo(150)
//            make.height.equalTo(0)
//        }
        return button
    }()
    
    lazy var signWithAnonymousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("가입하지 않고 둘러보기", for: .normal)
        button.setTitleColor(UIColor.tabButtonlightGrey, for: .normal)
        button.backgroundColor = .none
        button.layer.borderColor = UIColor.tabButtonlightGrey.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
//        button.snp.makeConstraints { make in
//            make.width.equalTo(100)
//            make.height.equalTo(20)
//        }
        return button
    }()
    
    private lazy var loginButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginButton, signWithAnonymousButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var loginCheckedLabel: UILabel = {
        let label = UILabel()
//        label.text = "아이디와 비밀번호를 확인해주세요❗️"
//        label.text = "로그인되었습니다✅"
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(UIColor.tabButtondarkGrey, for: .normal)
        button.backgroundColor = .none
        button.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        return button
    }()
    
    lazy var openPrivacyPolicyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("개인정보 처리방침", for: .normal)
        button.setTitleColor(UIColor.tabButtonlightGrey, for: .normal)
        button.backgroundColor = .none
        button.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        return button
    }()
    
    private lazy var signInStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [signInButton, openPrivacyPolicyButton])
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
        [titleLabel, emailPasswordStackView, loginButtonStackView, loginCheckedLabel, signInStackView]
            .forEach { self.addSubview($0) }
    }

    func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(200)
        }
        emailPasswordStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.height.equalTo(100)
        }
        loginCheckedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailPasswordStackView.snp.bottom).offset(15)
        }
        loginButtonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(100)
            make.top.equalTo(loginCheckedLabel.snp.bottom).offset(15)
            make.height.equalTo(100)
        }
        signInStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(loginButtonStackView.snp.bottom).offset(40)
        }
    }
}
