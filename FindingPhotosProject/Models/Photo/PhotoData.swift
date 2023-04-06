//
//  aa.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/30.
//

import Foundation
import RealmSwift

final class PhotoData: Object {
    
    @objc dynamic var id = "" // 기본키
    @objc dynamic var date = ""
    @objc dynamic var dateAdded = Date() // 새로 추가한 속성
    @objc dynamic var image: Data? = nil
    @objc dynamic var memo = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

