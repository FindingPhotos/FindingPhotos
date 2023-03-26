//
//  PhotoDetailViewController.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/26.
//

import UIKit
import SnapKit

class PhotoDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigation()
    }
    
    // MARK: - Selectors
    
    @objc func saveButtonTapped(_ sender: Any) {
        print("사진 저장")
    }

    
    
    // MARK: - Helpers

    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureNavigation() {
        let rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))

        navigationItem.rightBarButtonItem = rightButton
    }

}
