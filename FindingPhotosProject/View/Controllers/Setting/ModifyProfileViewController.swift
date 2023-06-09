//
//  ModifyProfileViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/28.
//

import UIKit
import RxSwift
import RxCocoa

final class ModifyProfileViewController: UIViewController {
    
    // MARK: - Propertys
    
    private let modifyProfileView = ModifyProfileView()
    
    private var viewModel = ModifyProfileViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        bindImagePicker()
        bindViewModel()
    }
    
    override func loadView() {
        view = modifyProfileView
    }

    // MARK: - Helpers
    
    func setValue() {
        navigationItem.title = "프로필 수정"
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
    }
    
    private func bindViewModel() {
        // Input
        modifyProfileView.nameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to:viewModel.input.textFieldText)
            .disposed(by: disposeBag)
        
        modifyProfileView.modifyButton.rx.tap
            .bind(to: viewModel.input.ModifyButtonTapped)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.output.userInformation
            .map { $0?.name }
            .bind(to: modifyProfileView.nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.userInformation
            .withUnretained(self)
            .map {viewController, userModel in
                guard let urlString = userModel?.profileImageUrl else { return }
                viewController.modifyProfileView.profileImageView.setImage(with: urlString)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.output.changedImage
            .bind(to: modifyProfileView.profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output.isModifiyFinished
            .subscribe { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindImagePicker() {
        modifyProfileView.imagePickerButton.rx.tap
            .flatMapLatest({ [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                    picker.view.tintColor = .black
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
            })
            .map { info in
                return info[.editedImage] as? UIImage
            }
            .bind(to: viewModel.input.selectedImage)
            .disposed(by: disposeBag)
    }
}
