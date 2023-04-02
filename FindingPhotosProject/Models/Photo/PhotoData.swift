//
//  aa.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/30.
//

import Foundation
import RealmSwift

class PhotoData: Object {
    
    @objc dynamic var id = "" // 기본키
    @objc dynamic var date = ""
    @objc dynamic var image: Data? = nil
    @objc dynamic var memo = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
