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
    
    
    // MARK: - LifeCycle
    override func layoutSubviews() {
        setSubViews()
        setLayout()
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
    }
    func setLayout() {
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
