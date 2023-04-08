//
//  ImageUploaderToFirestore.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/04/01.
//

import FirebaseStorage

struct ImageUploaderToFirestorage {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Bool) {
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
}
