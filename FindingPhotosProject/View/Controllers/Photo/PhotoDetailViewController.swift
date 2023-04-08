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


final class PhotoDetailViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var imagePicker = UIImagePickerController()
    private let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    
    private lazy var photoDetailView: PhotoDetailView = {
        let view = PhotoDetailView(frame: self.view.frame)
        self.view.addSubview(view)
        return view
    }()

    
    private let realmManager = RealmManager()
    var diary: PhotoData?
    
    private var defaultImage = UIImage(systemName: "addphoto")

    
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
        
        guard let photoData = diary else {
            let alert = UIAlertController(title: "🚫", message: "삭제할 항목이 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: "🗑", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            let image = self.photoDetailView.photoImageView.image ?? UIImage()
            self.realmManager.delete(photoData: photoData)
            self.popViewController()
        }
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }

    

    // MARK: - Helpers
    
    private func setUI() {
        imagePicker.delegate = self
        configureUI()
        configureNavigation()
        configureButtonActions()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    
        if let diary = diary, let imageData = diary.image {
            photoDetailView.photoImageView.image = UIImage(data: imageData)
            photoDetailView.memoTextView.text = diary.memo
        }
    }

    
    private func configureNavigation() {
        let deleteButton = UIButton(type: .custom)
        deleteButton.setImage(UIImage(named: "deleteButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        let deleteBarButtonItem = UIBarButtonItem(customView: deleteButton)

        let saveButton = UIButton(type: .custom)
        saveButton.setImage(UIImage(named: "saveButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)

        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 10

        navigationItem.rightBarButtonItems = [saveBarButtonItem, space, deleteBarButtonItem]

    }


    
    
//    // ⚠️ 여기 수정
    private func configureButtonActions() {
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
    private func openImagePicker() {
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
