//
//  SettingViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import SnapKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import MessageUI


final class SettingViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel = SettingViewModel()
    var disposeBag = DisposeBag()
    
    private lazy var dataSource = viewModel.dataSource(tableView: tableView)

    private let profileView = ProfileView()
    private let logoutView = LogoutView()
    
    private lazy var underBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .tabButtonlightGrey
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.identifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        print("DEBUG: inset:\(tableView.separatorInset.right)")

        return tableView
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
        setLayout()
        setValue()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBinding()
    }
    
    // MARK: - helpers
    
    func setupBinding() {
        viewModel.settingDatas
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource(tableView: tableView)))
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

}

extension SettingViewController: LayoutProtocol {
    
    func setValue() {
        view.backgroundColor = .white
        navigationItem.title = "프로필"
    }
    
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

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let locationPolicy = "https://thread-pike-aca.notion.site/Location-Information-Policy-443a4fa37b4f4cd489542774982eb70e"
                openSFSafari(url: locationPolicy)
            } else {
                let personalInformationPolicy = "https://thread-pike-aca.notion.site/Personal-Information-Policy-17a0bfbcb74446f8b6a166bd289e33d4"
                openSFSafari(url: personalInformationPolicy)
            }
        case 1:
            if indexPath.row == 0 {
                sendEmail(self: self, { })
            } else {
                let librariesDocument = "https://thread-pike-aca.notion.site/Used-Libraries-c4b0a2f97587488b985ce9876640a152"
                openSFSafari(url: librariesDocument)
            }
        default:
            break
        }
    }
}


extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
           controller.dismiss(animated: true, completion: nil)
       }

}
