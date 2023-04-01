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
        let logoutButtonTapped = PublishRelay<Void>()
        let signoutButtonTapped = PublishRelay<Void>()
    }
    struct Output {
        let didLogOut: Observable<Void>
        let didSignOut: Observable<Void>

    }
    var disposeBag = DisposeBag()
    
    let input = Input()
    lazy var output = transform(input: input)
    
    func transform(input: Input) -> Output {


        
        let logOut = input.logoutButtonTapped
            .map { _ in
                AuthManager.shared.logOut()
            }
            
            
        let signOut = input.signoutButtonTapped
            .map { _ in
                AuthManager.shared.deleteAccount()
            }
        
            
        return Output(didLogOut: logOut, didSignOut: signOut)
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
