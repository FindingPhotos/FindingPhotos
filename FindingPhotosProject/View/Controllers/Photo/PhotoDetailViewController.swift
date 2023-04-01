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
    private let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.view = photoDetailView
        configureUI()
        configureNavigation()
        bindButton()
    }
    
    // MARK: - Selectors
    
    @objc func deleteButtonTapped() {
        print("사진 삭제")
    }
    
    
    @objc func saveButtonTapped() {
        print("사진 저장")
        navigationController?.popViewController(animated: true)
        let photoViewController = navigationController?.viewControllers[0] as! PhotoViewController
        photoViewController.images.append(photoDetailView.photoImageView.image)

    }
    
    
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        self.view = photoDetailView
    }

    
    private func configureNavigation() {
        let deleteButton = UIBarButtonItem(image: UIImage(named: "deleteButton")?.withRenderingMode(.alwaysOriginal),
                                            style: .plain,
                                            target: self,
                                            action: #selector(deleteButtonTapped))
        
        let saveButton = UIBarButtonItem(image: UIImage(named: "saveButton")?.withRenderingMode(.alwaysOriginal),
                                          style: .plain,
                                          target: self,
                                          action: #selector(saveButtonTapped))
        
        navigationItem.rightBarButtonItems = [saveButton, deleteButton]
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
