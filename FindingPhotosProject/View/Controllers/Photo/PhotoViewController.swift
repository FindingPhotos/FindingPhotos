//
//  PhotoViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import UIKit
import PhotosUI

final class PhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    var imagePicker = UIImagePickerController()
    let detailViewController = PhotoDetailViewController()
//    let navigationItem = UINavigationItem(title: "나의 앨범")
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - Selectors
    
    @objc func nextButtonTapped(_ sender: Any) {
        print("DetailVC로 화면 전환")
        detailViewController.modalPresentationStyle = .fullScreen
//        self.present(detailViewController, animated: true)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .tabButtondarkGrey
        
    
    }
    
    private func configureNavigation() {
        navigationItem.title = "나의 앨범"
        let rightButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(nextButtonTapped))

        navigationItem.rightBarButtonItem = rightButton
//        navigationBar.setItems([navigationItem], animated: true)
    }
    
 
    
    
    
    
}
