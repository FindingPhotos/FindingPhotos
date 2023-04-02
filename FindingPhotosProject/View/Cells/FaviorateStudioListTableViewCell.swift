//
//  FaviorateStudioListTableViewCell.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/31.
//

import UIKit

final class FaviorateStudioListTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let cellIdentifier = "FaviorateStudioListTableViewCell"
    private let studioNameLabel: UILabel = {
        let studioNameLabel = UILabel()
        studioNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return studioNameLabel
    }()
    private let studioAddressLabel: UILabel = {
        let studioAddressLabel = UILabel()
        studioAddressLabel.font = UIFont.boldSystemFont(ofSize: 15)
        studioAddressLabel.textColor = .tabButtonlightGrey
        return studioAddressLabel
    }()
    private lazy var studioInformationStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [studioNameLabel, studioAddressLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.setImage(UIImage(named: "initialButton"), for: .normal)
        return likeButton
    }()
    override func layoutSubviews() {
        setSubViews()
        setLayout()
    }
    func bind(photoStudio: PhotoStudio) {
        studioNameLabel.text = photoStudio.title
        studioAddressLabel.text = photoStudio.roadAddress
    }
}
// MARK: - LayoutProtocol
extension FaviorateStudioListTableViewCell: LayoutProtocol {
    func setSubViews() {
        addSubview(studioInformationStackView)
        addSubview(likeButton)
    }
    func setLayout() {
        studioInformationStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(30)
        }
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(studioInformationStackView.snp.centerY)
            make.right.equalToSuperview().offset(-30)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
}
