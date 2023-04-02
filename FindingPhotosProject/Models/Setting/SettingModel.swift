//
//  SettingModel.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/27.
//
import Foundation
import RxSwift
import RxDataSources

struct Document {
    var title: String
}

struct SectionOfDocument {
    var header: String
    var items: [Document]
}

extension SectionOfDocument: SectionModelType {
    typealias Item = Document
    
    init(original: SectionOfDocument, items: [Item]) {
        self = original
        self.items = items
    }
}


