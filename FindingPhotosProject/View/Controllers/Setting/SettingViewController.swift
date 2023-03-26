//
//  SettingViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import SnapKit
import RxSwift

final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let profileView = ProfileView()
    private let logoutView = LogoutView()
    
    private lazy var underBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .tabButtonlightGrey
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.cellName)
        tableView.backgroundColor = .systemBlue
        return tableView
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
        setLayout()
        view.backgroundColor = .white
        navigationItem.title = "프로필"
    }
    
    
    // MARK: - helpers
    
    
}

extension SettingViewController: LayoutProtocol {
    func setSubViews() {
        [profileView, underBarView, tableView, logoutView].forEach { self.view.addSubview($0) }
    }
    
    func setLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
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
            make.height.equalTo(350)
        }
        logoutView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}
