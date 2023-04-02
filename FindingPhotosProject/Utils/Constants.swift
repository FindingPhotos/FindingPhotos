//
//  Constants.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/28.
//

import Foundation
import FirebaseFirestore

public struct SystemIconName {
    private init() { }
    
    static let plusCircleFill = "plus.circle.fill"
    
}


struct FirestoreAddress {
    static let collectionUsers = Firestore.firestore().collection("users")

}
