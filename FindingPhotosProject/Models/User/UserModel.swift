//
//  UserModel.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/29.
//

import UIKit

struct UserModel {
    var name: String
    var email: String
    var uid: String
    var profileImageUrl: String?
    
    init(name: String, email: String, uid: String, profileImageUrl: String? = nil) {
        self.name = name
        self.email = email
        self.uid = uid
        self.profileImageUrl = profileImageUrl
    }
}
