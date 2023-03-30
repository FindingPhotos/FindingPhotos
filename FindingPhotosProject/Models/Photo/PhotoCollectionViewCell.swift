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
    private let imageView = UIImageView()
    
    
    // MARK: - LifeCycle

    
    // MARK: - Helpers

    func setup(with image: UIImage) {
        addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        imageView.backgroundColor = .darkGray
    }
    
    
}
