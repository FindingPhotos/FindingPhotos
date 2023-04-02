//
//  PhotoStudios.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/28.
//

import Foundation
import RealmSwift

// MARK: - PhotoStudios
struct PhotoStudios: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let category, description, telephone, address: String
    let roadAddress, mapx, mapy: String
}

class PhotoStudio: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var roadAddress: String = ""
    convenience init(name: String, address: String) {
        self.init()
        self.title = name
        self.roadAddress = address
    }
}
