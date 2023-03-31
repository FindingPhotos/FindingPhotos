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

enum SettingSection: String {
    case policies = "약관 및 정책"
    case developerInformation = "개발자 정보"
}

final class SettingViewModel: ViewModelType {
    
    struct Input {
        let user = BehaviorRelay<UserModel>(value: UserModel(name: "John", email: "FF@b.", uid: "aaa"))
        let logoutButtonTapped = PublishRelay<Void>()
        let signoutButtonTapped = PublishRelay<Void>()
    }
    struct Output {
        let userName: Observable<String>
        let userImage: Observable<UIImage?>
    }
    var disposeBag = DisposeBag()
    
    let input = Input()
    lazy var output = transform(input: input)
    
    func transform(input: Input) -> Output {

        input.logoutButtonTapped
            .map { _ in
                AuthManager.shared.logOut()
            }
            .subscribe()
            .disposed(by: disposeBag)
            
        input.signoutButtonTapped
            .map { _ in
                AuthManager.shared.deleteAccount()
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        let userName = input.user.map { return $0.name }
        let userImage = input.user.map { return $0.profileImage }
            
        return Output(userName: userName,
                      userImage: userImage)
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
