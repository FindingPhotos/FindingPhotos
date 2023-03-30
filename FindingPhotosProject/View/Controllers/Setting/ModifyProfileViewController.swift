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
        setSubViews()
        setLayout()
        setImagePicker()
        bindViewModel()
    }
    
    // MARK: - Helpers
    
    private func bindViewModel() {
        // Input
        modifyProfileView.modifyButton.rx.tap
            .withUnretained(self)
            .subscribe { viewController, _ in
                viewController.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        modifyProfileView.nameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to:viewModel.input.textFieldText)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.output.changedImage
            .bind(to: modifyProfileView.profileImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    private func setImagePicker() {
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

extension ModifyProfileViewController: LayoutProtocol {
    
    func setValue() {
        navigationItem.title = "프로필 수정"
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
    }
    
    func setSubViews() {
        view.addSubview(modifyProfileView)
    }
    
    func setLayout() {
        modifyProfileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    
    
}
