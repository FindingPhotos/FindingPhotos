//
//  PhotoDetailViewModel.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/04/17.
//

import UIKit

final class PhotoDetailViewModel {
    
    // MARK: - Properties
    
    private var realmManager = RealmManager()
    private var photoData: PhotoData?
    
    // MARK: - Helpers
    
    func savePhotoData(date: String?, memo: String?, image: UIImage?) {
        
        guard let date = date else { return }
        
        let newData = PhotoData()
        if let memo = memo {
            newData.memo = memo
        } else {
            newData.memo = "" // 기본값 설정
        }
        
        if let photoData = photoData {
            newData.id = photoData.id
            realmManager.update(photoData: newData, image: image!)
        } else {
            newData.id = UUID().uuidString
            
            if let image = image {
                realmManager.save(photoData: newData, image: image)
            }
        }
    }
    
    func deletePhotoData(_ photoData: PhotoData?) {
        if let photoData = photoData {
            self.realmManager.delete(photoData: photoData)
        }
    }
    
    func getPhotoData() -> PhotoData? {
        return photoData
    }
    
}
