//
//  aa.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/30.
//

import Foundation
import RealmSwift


class PhotoData: Object {

    @objc dynamic var date = ""
    @objc dynamic var image: Data? = nil
    @objc dynamic var memo = ""
}

