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
import RxViewController
import MessageUI
import Kingfisher


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
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        bindViewModel()
//    }
    
    override func loadView() {
        view = settingView
    }
    // MARK: - helpers
    
    func setValue() {
        navigationItem.title = "프로필"
        navigationItem.titleView?.tintColor = .tabButtondarkGrey
    }
    func bindViewModel() {
        //input
//        settingView.logoutButton.rx.tap
//            .bind(to: viewModel.input.logoutButtonTapped)
//            .disposed(by: disposeBag)
        
//        settingView.signoutButton.rx.tap
//            .bind(to: viewModel.input.signoutButtonTapped)
//            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)
        
        settingView.logoutButton.rx.tap
            .flatMap { _ in
                self.showAlertWithCancelRx("로그아웃 하시겠습니까?", "메인 화면으로 돌아갑니다.")
            }
            .flatMap { actionType -> Observable<Bool> in
                switch actionType {
                case .ok:
                    return Observable.create { observer in
                        observer.onNext(true)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                case .cancel:
                    return Observable.empty()
                }
            }
            .bind(to: self.viewModel.input.logoutButtonTapped)
            .disposed(by: disposeBag)
            
        
        settingView.signoutButton.rx.tap
            .flatMap { _ in
                self.showAlertWithCancelRx("회원탈퇴 하시겠습니까?", "삭제된 계정은 복구할 수 없습니다.")
            }
            .flatMap { actionType -> Observable<Bool> in
                switch actionType {
                case .ok:
                    return Observable.create { observer in
                        observer.onNext(true)
                        observer.onCompleted()
                        return Disposables.create()
                    }
                case .cancel:
                    return Observable.empty()
                }
            }
            .bind(to: self.viewModel.input.signoutButtonTapped)
            .disposed(by: disposeBag)
        
        
        // Output
        viewModel.output.didLogOut
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.output.didSignOut
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.output.userName
//            .debug("userName")
            .bind(to: settingView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.isUserInformationExist
            .bind(to: settingView.profileSetButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.userInformation
//            .debug("userInfo")
            .withUnretained(self)
            .map {viewController, userModel in
                if userModel == nil {
                    guard let image = UIImage(systemName: "person.fill") else { return }
                    image.withTintColor(.tabButtondarkGrey, renderingMode: .alwaysTemplate)
                    viewController.settingView.profileImageView.image = image
                } else {
                    guard let urlString = userModel?.profileImageUrl else { return }
                    viewController.settingView.profileImageView.setImage(with: urlString)
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
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
