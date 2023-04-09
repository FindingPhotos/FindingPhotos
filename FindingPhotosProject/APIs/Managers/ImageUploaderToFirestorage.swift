//
//  ImageUploaderToFirestore.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/04/01.
//

import FirebaseStorage
import RxSwift

struct ImageUploaderToFirestorage {
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        ref.putData(imageData, metadata: nil) { metaData, error in
            if let error = error {
                print("DEBUG : 이미지파일 로드 실패 \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
    
    static func uploadImageRx(image: UIImage?) -> Observable<String?> {
        return Observable.create { observer in
            guard let image,
                  let imageData = image.jpegData(compressionQuality: 0.75) else {
                observer.onNext(nil)
                return Disposables.create()
            }
            let filename = NSUUID().uuidString
            let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
            ref.putData(imageData, metadata: nil) { metaData, error in
                if let error = error {
                    print("DEBUG : 이미지파일 로드 실패 \(error.localizedDescription)")
                    observer.onNext(nil)
                    return
                }
                ref.downloadURL { url, error in
                    guard let imageUrl = url?.absoluteString else { return }
                    observer.onNext(imageUrl)
                }
            }
            return Disposables.create()
        }
    }
}
