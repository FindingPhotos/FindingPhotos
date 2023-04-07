//
//  photoCollectionViewCell.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/30.
//

import UIKit
import SnapKit


final class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "PhotoCollectionViewCell"
    var imageView = UIImageView()
    
    lazy var highlightIndicator: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    lazy var selectIndicator: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "checkMark"))
        imageView.isHidden = true
        return imageView
    }()
    
    
    // MARK: - LifeCycle
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
            selectIndicator.isHidden = !isSelected
        }
    }
    
    // MARK: - Helpers

    func setup(with image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }
}

extension PhotoCollectionViewCell: LayoutProtocol {
    func setSubViews() {
        addSubview(imageView)
        addSubview(highlightIndicator)
        addSubview(selectIndicator)
    }
    
    func setLayout() {
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    
        highlightIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectIndicator.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
            make.width.height.equalTo(20)
        }
    }
}
