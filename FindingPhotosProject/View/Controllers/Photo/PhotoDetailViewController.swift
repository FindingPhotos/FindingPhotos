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
    
    var defaultImage = UIImage(systemName: "addphoto")

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - Selectors
    
    @objc func saveButtonTapped() {
        // 저장할 데이터 객체 생성
        guard let date = photoDetailView.dateLabel.text else { return }
        
        let newData = PhotoData()
        newData.date = date
        newData.memo = photoDetailView.memoTextView.text
        
        if diary != nil {
            newData.id = diary!.id
            let image = photoDetailView.photoImageView.image ?? UIImage()
            realmManager.update(photoData: newData, image: image)
        } else {
            // 객체가 존재하지 않으면 새로운 객체로 저장
            newData.id = UUID().uuidString
            
            if let image = photoDetailView.photoImageView.image, image != UIImage(named: "addphoto") {
                     realmManager.save(photoData: newData, image: image)
                     popViewController()
                 } else {
                     let alert = UIAlertController(title: "📸", message: "사진을 추가하세요.", preferredStyle: .alert)
                     let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                     alert.addAction(okAction)
                     present(alert, animated: true, completion: nil)
                 }

        }

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

extension UIViewController {
    func alert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
