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
        // 저장할 데이터 객체 생성
        let newData = PhotoData()
        newData.id = UUID().uuidString
        newData.date = photoData.date
        newData.memo = photoData.memo
        newData.image = image.pngData()
        
        // Realm 데이터베이스에 데이터 저장
        try! realm.write {
            realm.add(newData)
        }
    }
    
    func getData(withId id: String) -> PhotoData? {
        // 기존 데이터 가져오기
        let existingData = realm.objects(PhotoData.self).filter { $0.id == id }.first
        return existingData
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

    
    func update(photoData: PhotoData, image: UIImage) {
        // 기존 데이터 업데이트
        guard let existingData = getData(withId: photoData.id) else {
            return
        }
        do {
            try realm.write {
                existingData.date = photoData.date
                existingData.memo = photoData.memo
                existingData.image = image.pngData()
            }
        } catch {
            print("????")
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
