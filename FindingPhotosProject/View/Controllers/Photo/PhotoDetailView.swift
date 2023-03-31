//
//  PhotoDetailVieq.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/28.
//

import UIKit

class PhotoDetailView: UIView {
    
    // MARK: - Properties

    let imagePicker = UIImagePickerController()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        
        // ⚠️ 이거 안됨
        datePicker.backgroundColor = .clear
        
        return datePicker
    }()
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "addphoto")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var memoLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "memo")
        return imageView
    }()
    
    lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        return textView
    }()
    
    lazy var memoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "memoImage")
        return imageView
    }()
    

    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.backgroundColor = .white
    }
}


// MARK: - Layout

extension PhotoDetailView: LayoutProtocol {
    
    func setSubViews() {
        self.addSubview(datePicker)
        self.addSubview(photoImageView)
        self.addSubview(addPhotoButton)
        self.addSubview(memoLabel)
        self.addSubview(memoImageView)
        self.addSubview(memoTextView)
    }
    
    func setLayout() {
        datePicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(110)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(datePicker)
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.width.equalTo(350)
            make.height.equalTo(470)
        }
        
        addPhotoButton.snp.makeConstraints { make in
            make.centerX.equalTo(photoImageView.snp.centerX)
            make.centerY.equalTo(photoImageView.snp.centerY)
            make.width.equalTo(photoImageView.snp.width)
            make.height.equalTo(photoImageView.snp.height)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(28)
            make.width.equalTo(75)
            make.height.equalTo(30)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.centerX.equalTo(memoImageView.snp.centerX)
            make.centerY.equalTo(memoImageView.snp.centerY)
            make.width.equalTo(315)
            make.height.equalTo(50)
        }
        
        memoImageView.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(80)
            make.top.equalTo(memoLabel.snp.bottom).offset(-15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        memoImageView.layer.zPosition = CGFloat(-1)
    }
    
}




