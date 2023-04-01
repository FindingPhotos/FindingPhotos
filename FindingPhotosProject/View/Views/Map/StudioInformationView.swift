//
//  StudioInformationView.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/30.
//

import UIKit

import SnapKit

final class StudioInformationView: UIView {
    // MARK: - Properties
    private let studioNameLabel: UILabel = {
        let studioNameLabel = UILabel()
        studioNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        return studioNameLabel
    }()
    private let studioAddressLabel: UILabel = {
        let studioAddressLabel = UILabel()
        studioAddressLabel.font = UIFont.boldSystemFont(ofSize: 13)
        studioAddressLabel.textColor = .tabButtonlightGrey
        return studioAddressLabel
    }()
    private lazy var studioInformationStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [studioNameLabel, studioAddressLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let distanceLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        return likeButton
    }()
    // MARK: - Lifecycle
    override func layoutSubviews() {
        setValue()
        setSubViews()
        setLayout()
    }
    // MARK: - Helpers
    func bind(item: Item, distance: Double) {
        studioNameLabel.text = item.title.htmlEscaped
        studioAddressLabel.text = item.address.htmlEscaped
        distanceLabel.text = String(round(distance / 100) * 100 / 1000) + "km"
    }
}
// MARK: - LayoutProtocol
extension StudioInformationView: LayoutProtocol {
    func setValue() {
        backgroundColor = .white
    }
    func setSubViews() {
        addSubview(studioInformationStackView)
        addSubview(distanceLabel)
        addSubview(likeButton)
    }
    func setLayout() {
        studioInformationStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(30)
        }
        distanceLabel.snp.makeConstraints { make in
            make.left.equalTo(studioInformationStackView.snp.right).offset(5)
            make.bottom.equalTo(studioInformationStackView.snp.bottom)
        }
        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(30)
        }
    }
}
