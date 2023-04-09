//
//  SettingViewModel.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/27.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import FirebaseAuth

enum SettingSection: String {
    case policies = "약관 및 정책"
    case developerInformation = "개발자 정보"
}

final class SettingViewModel: ViewModelType {
    
    struct Input {
        let logoutButtonTapped = PublishRelay<Bool>()
        let signoutButtonTapped = PublishRelay<Bool>()
        let viewWillAppear = BehaviorRelay<Bool>(value: false)
    }
    struct Output {
        let didLogOut: Observable<Void>
        let didSignOut: Observable<Void>
        let userInformation: Observable<UserModel?>
        let userName: Observable<String>
        let isUserInformationExist: Observable<Bool>
    }
    var disposeBag = DisposeBag()
    
    let input = Input()
    lazy var output = transform(input: input)
    
    func transform(input: Input) -> Output {

        let logOut = input.logoutButtonTapped
            .map { bool in
                if bool {
                    AuthManager.shared.logOut()
                }
            }
            
        let signOut = input.signoutButtonTapped
            .map { bool in
                if bool {
                    AuthManager.shared.deleteAccount()
                }
            }


        let user = input.viewWillAppear
            .flatMap { _ in
                AuthManager.shared.getUserInformation()
            }
            .share()

                
        let userName = user.map { userModel in
            if userModel == nil {
                return "익명으로 로그인되었습니다."
            } else {
                return userModel!.name
            }
        }
            
        let isUserInformationExist = user.map { userModel in
            if userModel == nil {
                return true
            } else {
                return false
            }
        }
        
        return Output(didLogOut: logOut,
                      didSignOut: signOut,
                      userInformation: user,
                      userName: userName,
                      isUserInformationExist: isUserInformationExist)
    }
    
    let settingDatas = BehaviorRelay<[SectionOfDocument]>(value: [
        SectionOfDocument(header: SettingSection.policies.rawValue,
                          items: [Document(title: "위치정보 이용약관"),
                                  Document(title: "개인정보 처리방침")]),
        SectionOfDocument(header: SettingSection.developerInformation.rawValue,
                          items: [Document(title: "문의"),
                                  Document(title: "외부 라이브러리")])
    ])
    
    func dataSource(tableView: UITableView) -> RxTableViewSectionedReloadDataSource<SectionOfDocument> {
        tableView.delegate = nil
        tableView.dataSource = nil
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfDocument>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
                cell.configure(item)
                return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        return dataSource
    }
}
