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

class SettingViewModel{
    
    
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
