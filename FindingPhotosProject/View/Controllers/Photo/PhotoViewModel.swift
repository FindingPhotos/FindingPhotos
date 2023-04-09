//
//  customViewModel.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/28.
//

import UIKit
import RealmSwift

// PhotoData를 가져오고, View에 필요한 데이터를 처리하여 제공

final class PhotoViewModel {
   
    static let realmManager = RealmManager.shared
    
    var photos: Results<PhotoData>?
    
    init() {
        self.photos = PhotoViewModel.realmManager.fetchAll()
    }
    
    func numberOfItems() -> Int {
        return photos?.count ?? 0
    }
    
    func photoData(at indexPath: IndexPath) -> PhotoData? {
        return photos?[indexPath.row]
    }
    
}
