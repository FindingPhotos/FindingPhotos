//
//  PhotoDetailViewController.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/26.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import RealmSwift


class PhotoDetailViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private lazy var photoDetailView = PhotoDetailView(frame: self.view.frame)
    private var imagePicker = UIImagePickerController()
    private let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus(
    )
    // iPhone 내부에 저장된 realm 파일의 주소를 찾아서 알려주는 코드
    let localRealm = try! Realm()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.view = photoDetailView
        configureUI()
        configureNavigation()
        bindButton()
        realmSetting()
    }
    
    // MARK: - Selectors
    
    @objc func saveButtonTapped() {
        print("사진 저장")
        navigationController?.popViewController(animated: true)
        let photoViewController = navigationController?.viewControllers[0] as! PhotoViewController
        photoViewController.images.append(photoDetailView.photoImageView.image)
//        let task = PhotoData(date: photoDetailView.datePicker.date, imageData: photoDetailView.photoImageView.image!, memo: photoDetailView.memoTextView.text!)
        
//        try! localRealm.write {
//            localRealm.add(task)
//        }
    }
    
    
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureNavigation() {
        let rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    
//    // ⚠️ 여기 수정
    func bindButton() {
        photoDetailView.addPhotoButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { photoDetailViewController, _ in
                photoDetailViewController.openImagePicker()
            })
            .disposed(by: disposeBag)
//            .subscribe(onNext: { photoDetailViewController
//                photode.openImagePicker()
//            })
//            .disposed(by: disposeBag)
//
//        imagePicker.rx.didFinishPickingMediaWithInfo
//        // ⚠️ 여기 정리
//            .withUnretained(self)
//            .bind { photoDetailViewController ,info in
//                photoDetailViewController.dismiss(animated: true, completion: nil)
//                if let img = info[.originalImage] as? UIImage {
//                    photoDetailViewController.photoDetailView.photoImageView.image = img
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
    
    private func realmSetting() {
        // 이 코드를 통해 현재 Realm파일이 저장된 위치의 주소를 확인할 수 있음
        // 해당 주소를 이용해 Realm파일에 바로 접근하여 저장된 데이터를 확인할 수 있음
        print("Realm is located at", localRealm.configuration.fileURL!)
    }
    
    deinit {
        print("deinit!!!")
    }
}

// MARK: - 이미지 할당
//
//extension PhotoDetailViewController {
//    func openImagePicker() {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            imagePicker.sourceType = .photoLibrary
//            imagePicker.allowsEditing = false
//            present(imagePicker, animated: true, completion: nil)
//        }
//    }
//}



extension PhotoDetailViewController: UIImagePickerControllerDelegate {
    func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            dismiss(animated: true, completion: nil)
            if let img = info[.originalImage] as? UIImage {
                self.photoDetailView.photoImageView.image = img
            }
        }
}
