//
//  APIKeys.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import Foundation

extension Bundle {
    var firebaseApiKey: String {
        guard let file = self.path(forResource: "APIKeyList", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["firebaseApiKey"] as? String else { fatalError("APIKeyList에 firebaseApiKey 설정을 해주세요") }
        return key
    }

    var naverMapApiKey: String {
        guard let file = self.path(forResource: "APIKeyList", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["naverMapApiKey"] as? String else { fatalError("APIKeyList에 naverMapApiKey 설정을 해주세요") }
        return key
    }
}

