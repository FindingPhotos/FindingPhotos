//
//  PhotoViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import UIKit
import PhotosUI
import RxSwift
import RealmSwift

final class PhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = PhotoViewModel()
//    private let realmManager = RealmManager.shared
//    private var photos: Results<PhotoData>?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
        
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigation()
        setSubViews()
        setLayout()
        collectionView.reloadData()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    // MARK: - Selectors
    
    @objc func addButtonTapped(_ sender: Any) {
//        let detailViewController = PhotoDetailViewController()
//        let photoDetailVC = PhotoDetailViewController()
        let photoDetailVC = PhotoDetailViewController()
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
    
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .tabButtondarkGrey
    }
    
    private func configureNavigation() {
        navigationItem.title = "나의 앨범"
        
        let addButton = UIBarButtonItem(image: UIImage(named: "addButton")?.withRenderingMode(.alwaysOriginal),
                                         style: .plain,
                                         target: self,
                                         action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

}




// MARK: - CollectionView

extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
//        guard let cellImageData = photos![indexPath.row].image else { return UICollectionViewCell() }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell,
              let photoData = viewModel.photoData(at: indexPath),
              let imageData = photoData.image else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(data: imageData)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let photo = photos?[indexPath.row] else { return }
//        let photoDetailVC = PhotoDetailViewController()
//        photoDetailVC.diary = photo
        
        guard let photoData = viewModel.photoData(at: indexPath) else { return }
        let photoDetailVC = PhotoDetailViewController()
        photoDetailVC.diary = photoData
        
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
    
}
    // MARK: - FlowLayout

    extension PhotoViewController: UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width: CGFloat = (collectionView.frame.width / 3) - 1.0
            return CGSize(width: width, height: width)
        }
        
    }



// MARK: - Layout Extension 

extension PhotoViewController: LayoutProtocol {
    func setSubViews() {
        view.addSubview(collectionView)
    }
    
    func setLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(150)
        }
    }
    
    
}
