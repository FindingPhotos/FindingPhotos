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
    
    let realmManager = RealmManager()
    var diary: PhotoData?

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Selectors
    
    @objc func saveButtonTapped() {
        
        // 저장할 데이터 객체 생성
        guard let date = photoDetailView.dateLabel.text else { return }
        let newData = PhotoData()
        newData.date = date
        newData.memo = photoDetailView.memoTextView.text
        
        // Realm 데이터베이스에 데이터 저장
        let image = photoDetailView.photoImageView.image ?? UIImage()
        realmManager.save(photoData: newData, image: image)

        popViewController()
        
    }

    @objc func deleteButtonTapped() {

        guard let photoData = diary else { return }
        
        // Realm 데이터베이스에서 데이터 삭제
        let image = photoDetailView.photoImageView.image ?? UIImage()
        realmManager.delete(photoData: photoData, image: image)
        
        popViewController()
    }
    
    

    // MARK: - Helpers
    
    private func setUI() {
        imagePicker.delegate = self
        self.view = photoDetailView
        configureUI()
        configureNavigation()
        configureButtonActions()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        self.view = photoDetailView
        
        if let diary = diary, let imageData = diary.image {
            photoDetailView.photoImageView.image = UIImage(data: imageData)
            photoDetailView.memoTextView.text = diary.memo
        }
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
    func configureButtonActions() {
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
    
    private func popViewController() {
        navigationController?.popViewController(animated: true)
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
