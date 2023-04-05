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
        
        // 1️⃣질문: 같은 output에서 bind하는 VC 인스턴스가 다를 땐 따로 mapping 후 bind 하는게 맞을까?
        viewModel.output.userInformation
            .debug("--")
            .map { userModel in
                if userModel == nil {
                    return "익명으로 로그인되었습니다."
                } else {
                    return userModel?.name
                }
            }
            .bind(to: settingView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.userInformation
            .debug()
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
        
        viewModel.output.userInformation
            .map { userModel in
                if userModel == nil {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: settingView.profileSetButton.rx.isHidden)
            .disposed(by: disposeBag)
        /*
         // userModel에서 image로 바로 매핑해 return 하려던 방법
         // 하지만 kf/Urlsession 모두 다운받은 이미지를 바로 방출하는 방법을 못찾겠다.
        viewModel.output.userInformation
            .debug()
            .map { userModel in
                if userModel == nil {
                    guard let image = UIImage(systemName: "person.fill") else { return UIImage()}
//                    image.withTintColor(.tabButtondarkGrey, renderingMode: .alwaysTemplate)
                    return image
                } else {
                    guard let urlString = userModel?.profileImageUrl,
                          let imageUrl = URL(string: urlString) else { return UIImage()}
                    lazy var fetchedImage = UIImage()
                    URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                        guard let data,
                              let image = UIImage(data: data) else { return }
                        fetchedImage = image
                    }.resume()
                    return fetchedImage
                }
            }
            .bind(to: settingView.profileImageView.rx.image)
            .disposed(by: disposeBag)
*/

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
