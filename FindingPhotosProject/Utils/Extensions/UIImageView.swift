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
                    self?.kf.setImage(with: resource)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
