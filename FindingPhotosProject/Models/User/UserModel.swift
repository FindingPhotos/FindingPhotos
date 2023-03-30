//
//  UserModel.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/29.
//

import UIKit

struct UserModel {
    var name: String
    var profileImage: UIImage?
    
    init(name: String, profileImage: UIImage? = nil) {
        self.name = name
        self.profileImage = profileImage
    }
}
