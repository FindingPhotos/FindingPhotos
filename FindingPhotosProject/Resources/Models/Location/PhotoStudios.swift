//
//  PhotoStudios.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/28.
//

import Foundation

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
