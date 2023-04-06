//
//  PhotoDetailVieq.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/28.
//

import UIKit

final class PhotoDetailView: UIView {
    
    // MARK: - Properties

    let imagePicker = UIImagePickerController()
    
    lazy var yearLabel: UILabel = {
       let dateLabel = UILabel()
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy"
        let today = myFormatter.string(from: Date())
        dateLabel.text = today
        dateLabel.textAlignment = .left
        dateLabel.textColor = .darkGray
        dateLabel.font = UIFont.systemFont(ofSize: 32, weight: .black)
        
        // ⭐️ 폰트 동적할당
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.5 // 최소 스케일링 비율
        dateLabel.numberOfLines = 0 // 필요한 만큼 행 수를 표시하도록 설정
        dateLabel.sizeToFit() // 레이블의 크기를 내용에 맞게 자동 조정
        return dateLabel
    }()
    
    lazy var dateLabel: UILabel = {
       let dateLabel = UILabel()
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "MM월 dd일"
        let today = myFormatter.string(from: Date())
        dateLabel.text = today
        dateLabel.textAlignment = .left
        dateLabel.textColor = .darkGray
        dateLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        return dateLabel
    }()
    
    lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yearLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
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
        self.addSubview(dateStackView)
        self.addSubview(photoImageView)
        self.addSubview(addPhotoButton)
        self.addSubview(memoLabel)
        self.addSubview(memoImageView)
        self.addSubview(memoTextView)
    }
    
    func setLayout() {

        dateStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            
            // 부모 뷰의 가로 크기의 80%와 세로 크기의 60%에 해당하는 크기
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.55)
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




