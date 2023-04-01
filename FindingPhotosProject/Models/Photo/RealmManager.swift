//
//  RealmManager.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/30.
//

import RealmSwift


class RealmManager {
    

    let realm = try! Realm()
    
    // MARK: - Create
    
    func save(photoData: PhotoData) {
        do {
            try realm.write {
                realm.add(photoData)
            }
        } catch {
            print("Error saving category \(error)")
            
        }
    }
 
    
}
