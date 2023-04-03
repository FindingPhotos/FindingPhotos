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
        let logoutButtonTapped = PublishRelay<Void>()
        let signoutButtonTapped = PublishRelay<Void>()
    }
    struct Output {
        let didLogOut: Observable<Void>
        let didSignOut: Observable<Void>
        let userInformation: Observable<UserModel?>
        // 1️⃣ 수정 후 돌아온 settingVC에서 유저 모델이 업데이트되지 않는 문제
        // 예상 원인: 옵저버블 타입의 유저 인포메이션이 ViewDidLoad될 때 실행되고 스트림이 끝나기 때문.
        // 시도: BehaviorRelay 타입으로 바꾸고, AuthManager를 통해 (옵저버 아닌) UserModel을 반환
        //        transform 메서드 내에서 반환된 userModel을 BehaviorRelay의 기본값으로 지정, 아웃풋으로 반환.
        // 실패: BehaviorRealy가 두 번 실행되고, 첫 번째 userModel을 nil로 반환.
        //      nil 값으로 VC에서 bind가 끝난 후, BehaviorRealy가 재실행되어 정상적 userModel 반환. 그러나 VC에 적용 안됨. 
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

        let user = AuthManager.shared.getUserInformation()
        
        return Output(didLogOut: logOut, didSignOut: signOut, userInformation: user)
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
