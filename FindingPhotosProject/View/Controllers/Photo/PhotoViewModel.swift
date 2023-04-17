//
//  customViewModel.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/28.
//

import UIKit
import RealmSwift

// 1) PhotoData 모델 데이터를 관리
// 2) numberOfItems와 photoData(at:) 메소드를 통해 View에 필요한 데이터를 제공

final class PhotoViewModel {
   
    static let realmManager = RealmManager.shared
    
    // Realm에서 가져온 PhotoData 객체의 리스트를 저장하는 변수
    // Results는 Realm에서 제공하는 객체로, 데이터베이스에서 쿼리한 결과를 동적으로 업데이트하는 리스트 형태로 반환
    var photos: Results<PhotoData>?
    
    // ViewModel을 생성될 때 필요한 초기화를 담당
    init() {
        self.photos = PhotoViewModel.realmManager.fetchAll()
    }
    
    // 셀의 개수 반환
    func numberOfItems() -> Int {
        return photos?.count ?? 0
    }
    
    // View에서 셀을 생성할 때, 해당 셀에 표시할 데이터를 제공하는 메소드로 사용
    func photoData(at indexPath: IndexPath) -> PhotoData? {
        return photos?[indexPath.row]
    }
    
}
