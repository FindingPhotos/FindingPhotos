//
//  SettingCell.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/26.
//

import SnapKit

final class SettingCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "SettingCell"
    
    let label = UILabel()
    
    // MARK: - Lifecycle

    override func layoutSubviews() {
        setSubViews()
        setLayout()
    }
    
    // MARK: - Heleprs
    
    func configure(_ item: Document) {
        label.text = item.title
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .tabButtondarkGrey
    }
}

extension SettingCell: LayoutProtocol {
    func setSubViews() {
        addSubview(label)
    }
    
    func setLayout() {
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    
}
