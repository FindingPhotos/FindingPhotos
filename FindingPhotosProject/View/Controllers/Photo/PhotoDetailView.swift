//
//  PhotoDetailVieq.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/28.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoDetailView: UIView {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    let datePicker = UIDatePicker()
    let imagePicker = UIImagePickerController()
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "addphoto")
        imageView.frame = CGRect(x: 0, y: 0, width: 350, height: 500)
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    lazy var addPhotoButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .darkGray
        button.setTitle("왜안나와", for: .normal)
        return button
    }()
    
    lazy var memoTextView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .gray
        return textView
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setSubViews()
        setLayouts()
        bindButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func saveButtonTapped(_ sender: Any) {
        print("사진 저장")
    }
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.backgroundColor = .white
        datePicker.datePickerMode = .date

    }
    
    private func setSubViews() {
        self.addSubview(datePicker)
        self.addSubview(photoImageView)
        self.addSubview(addPhotoButton)
        self.addSubview(memoTextView)
    }
    
    private func setLayouts() {
        datePicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(130)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(datePicker)
            make.top.equalTo(datePicker.snp.bottom).offset(20)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.centerX.equalTo(photoImageView)
            make.size.equalTo(photoImageView)
            make.top.equalTo(datePicker.snp.bottom).offset(20)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(85)
            make.top.equalTo(datePicker.snp.bottom).offset(300)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func bindButton() {
        addPhotoButton.rx.tap
            .subscribe(onNext: {
                print("이미지피커열기")
            })
            .disposed(by: disposeBag)
    }
    
 
}


