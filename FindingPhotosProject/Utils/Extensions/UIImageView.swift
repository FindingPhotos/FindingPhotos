//
//  UIImageView.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/04/03.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { [weak self] result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self?.image = image
                } else {
                    guard let url = URL(string: urlString) else { return }
                    let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                    let processor = DownsamplingImageProcessor(size: CGSize(width: 150, height: 150))
                    self?.kf.setImage(with: resource, options: [.processor(processor)] )
                }
            case .failure(let error):
                print("debug: error \(error.localizedDescription)")
            }
        }
    }
}
