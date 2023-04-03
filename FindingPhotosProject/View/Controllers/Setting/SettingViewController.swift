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

    var settingView = SettingView()
    lazy var tableView = settingView.tableView
    
    var viewModel = SettingViewModel()
    var disposeBag = DisposeBag()
    private lazy var dataSource = viewModel.dataSource(tableView: tableView)
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        bindTableView()
        bindViewModel()
    }
    
    override func loadView() {
        view = settingView
    }
    // MARK: - helpers
    
    func setValue() {
        navigationItem.title = "프로필"
    }
    func bindViewModel() {
        //input
        settingView.logoutButton.rx.tap
            .bind(to: viewModel.input.logoutButtonTapped)
            .disposed(by: disposeBag)
        settingView.signoutButton.rx.tap
            .bind(to: viewModel.input.signoutButtonTapped)
            .disposed(by: disposeBag)

        // Output
        viewModel.output.didLogOut
            .subscribe()
            .disposed(by: disposeBag)
        viewModel.output.didSignOut
            .subscribe()
            .disposed(by: disposeBag)
        viewModel.output.userInformation
            .debug("--")
//            .map { $0?.name }
            .map({ userModel in
                if userModel == nil {
                    return "익명으로 로그인되었습니다."
                } else {
                    return userModel?.name
                }
            })
            .bind(to: settingView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        // 2️⃣ userInformation은 Observable<UserModel?> 반환.
        // 이 때, 옵셔널인 userModel이 nil 일 경우 대체 텍스트를 입력하고 싶은데,
//        viewModel.output.userInformation
//            .debug("--")
//            .filter { $0 == nil }
//            .map { _ in "익명으로 로그인되었습니다." }
//            .bind(to: settingView.nameLabel.rx.text)
//            .disposed(by: disposeBag)

    }
    
    func bindTableView() {
        viewModel.settingDatas
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource(tableView: tableView)))
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        settingView.profileSetButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { settingViewController, event in
                settingViewController.navigationController?.pushViewController(ModifyProfileViewController(), animated: true)
            })
            .disposed(by: disposeBag)
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
