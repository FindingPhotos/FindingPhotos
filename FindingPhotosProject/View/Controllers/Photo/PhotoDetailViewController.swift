//
//  PhotoDetailViewController.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhotoDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private var photoDetailView: PhotoDetailView!
    // 뷰모델 넣기
    

    // MARK: - LifeCycle
    
    override func loadView() {
        super.loadView()

        photoDetailView = PhotoDetailView(frame: self.view.frame)
        self.view = photoDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigation()
//        view.addSubview(photoDetailView)
        
    }
    
    // MARK: - Selectors
    
    @objc func saveButtonTapped() {
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
