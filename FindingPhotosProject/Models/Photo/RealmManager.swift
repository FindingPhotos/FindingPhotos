//
//  RealmManager.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/30.
//

import RealmSwift


class RealmManager {
    
    let realm = try! Realm()
    
    static let shared = RealmManager()
    var photoList = [PhotoData]()
    
    // MARK: - Create

    func save(photoData: PhotoData, image: UIImage) {
        do {
            try realm.write {
                photoData.image = image.pngData()
                realm.add(photoData)
            }
        } catch {
            print("Error saving category \(error)")
            
        }
    }
    
    // MARK: - Read
    
    func fetchAll() -> Results<PhotoData> {
        let results = realm.objects(PhotoData.self)
        return results
    }
    
    func fetch(byDate date: String) -> PhotoData? {
        let predicate = NSPredicate(format: "date == %@", date)
        let results = realm.objects(PhotoData.self).filter(predicate)
        return results.first
    }
    
    // MARK: - Update

    func update(photoData: PhotoData, memo: String, image: UIImage) {
        do {
            try realm.write {
                photoData.memo = memo
                photoData.image = image.pngData()
            }
        } catch {
            print("Error updating photoData: \(error)")
        }
    }
    
    // MARK: - Delete
    
    func delete(photoData: PhotoData, image: UIImage) {
        do {
            try realm.write {
                photoData.image = image.pngData()
                realm.delete(photoData)
            }
        } catch {
            print("Error deleting photoData: \(error)")

        }
    }
    
    // MARK: - Sort
    
    func sortedPhotos() -> [PhotoData] {
        let photos = realm.objects(PhotoData.self).sorted(byKeyPath: "date", ascending: true)
        return photos.toArray()
    }

}

extension Results {
    func toArray<T>(ofType: T.Type = T.self) -> [T] {
        return compactMap { $0 as? T }
    }
    
}
