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
        setSubViews()
        setLayout()
        setValue()
        bindTableView()
        bindViewModel()
    }
    // MARK: - helpers
    func bindViewModel() {
        //input
       
        
        // Output
        viewModel.output.userName
            .bind(to: settingView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.userImage
            .bind(to: settingView.profileImageView.rx.image)
            .disposed(by: disposeBag)
        
    }
    
    func bindTableView() {
        viewModel.settingDatas
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource(tableView: tableView)))
            .disposed(by: disposeBag)

//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.itemSelected
            .subscribe { indexpath in
                indexpath.row
            }
        
        settingView.profileSetButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { settingViewController, event in
                settingViewController.navigationController?.pushViewController(ModifyProfileViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }

}

extension SettingViewController: LayoutProtocol {
    
    func setValue() {
        view.backgroundColor = .white
        navigationItem.title = "프로필"
    }
    
    func setSubViews() {
        view.addSubview(settingView)
    }
    
    func setLayout() {
        settingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
