//
//  SettingCell.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/26.
//

import SnapKit

final class SettingCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellName = "SettingCell"
    
    private let label = UILabel()
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    // MARK: - Heleprs
    
    private func setupLabel() {
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .systemGray
    }
    
}
