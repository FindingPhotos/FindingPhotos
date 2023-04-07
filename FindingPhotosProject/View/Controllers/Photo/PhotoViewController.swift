


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
    var selectedIndexes = [IndexPath]()
    var photoDatas: [PhotoData] = []
    var realmManager = RealmManager()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
        
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "addButton")?.withRenderingMode(.alwaysOriginal),
                                      style: .plain,
                                      target: self,
                                      action: #selector(addButtonTapped))
        return button
    }()
    
    lazy var selectBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "selectedButton")?.withRenderingMode(.alwaysOriginal),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didSelectButtonClicked))
        return button
    }()
    
    lazy var canceledBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "canceledButton")?.withRenderingMode(.alwaysOriginal),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didDeleteButtonClicked))
        return button
    }()
    
    lazy var deleteBarButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "deletedButtonGrey")?.withRenderingMode(.alwaysOriginal),
                                     style: .plain,
                                     target: self,
                                     action: #selector(didDeleteButtonClicked))
        return button
    }()
    
    
    // MARK: - Selected Button
    
    enum Mode {
        case view
        case select
    }

    var dictionarySelectedIndexPath: [IndexPath : Bool] = [:]

    var eMode: Mode = .view {
            didSet {
                switch eMode {
                case .view:
                    for (key, value) in dictionarySelectedIndexPath {
                        if value {
                            collectionView.deselectItem(at: key, animated: true)
                        }
                    }
                    dictionarySelectedIndexPath.removeAll()
                    
                    collectionView.allowsMultipleSelection = false
                    
                case .select:
                    selectBarButton.image = UIImage(named: "canceledButton")?.withRenderingMode(.alwaysOriginal)
                    selectBarButton.action = #selector(didCanceledButtonClicked)
                    
                    addButton.image = UIImage(named: "deleteButtonGrey")?.withRenderingMode(.alwaysOriginal)
                    addButton.action = #selector(didDeleteButtonClicked)
                    collectionView.allowsMultipleSelection = true
                }
            }
        }
    
    
        
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
        deleteSelectedItems()
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
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
            if eMode == .select {
                eMode = .view
                collectionView.alpha = 1.0
                if dictionarySelectedIndexPath.isEmpty {
                    deleteBarButton.isEnabled = false
                }
            } else {
                eMode = .select
                collectionView.alpha = 0.7
                deleteBarButton.isEnabled = true
            }
        }
    
    @objc func didCanceledButtonClicked(_ sender: UIBarButtonItem) {
        print("선택 취소")
        eMode = .view
        selectBarButton.image = UIImage(named: "selectedButton")?.withRenderingMode(.alwaysOriginal)
        selectBarButton.action = #selector(didSelectButtonClicked)
        addButton.image = UIImage(named: "addButton")?.withRenderingMode(.alwaysOriginal)
        addButton.action = #selector(addButtonTapped)
        collectionView.alpha = 1.0
        collectionView.reloadData()
    }
    
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            
            var deleteNeededIndexPaths: [IndexPath] = []
            
            for (key, value) in self.dictionarySelectedIndexPath {
                if value {
                    deleteNeededIndexPaths.append(key)
                }
            }
            
            for i in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
            }
            
            self.collectionView.deleteItems(at: deleteNeededIndexPaths)
            self.dictionarySelectedIndexPath.removeAll()
            self.collectionView.reloadData()

        }
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)

        
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .tabButtondarkGrey
    }

    
    private func configureNavigation() {
        navigationItem.title = "📷"
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 10
        navigationItem.rightBarButtonItems = [space, addButton, space, selectBarButton]
    }
    
    func deleteSelectedItems() {
        // 선택한 셀의 인덱스를 가져옴
        let selectedIndexPaths = Array(dictionarySelectedIndexPath.keys)
        
        // 선택한 셀의 데이터를 삭제
        for indexPath in selectedIndexPaths {
            let photoData = photoDatas[indexPath.item]
            delete(photoData)
            photoDatas.remove(at: indexPath.item)
        }
        
        // 선택 상태를 초기화
        dictionarySelectedIndexPath.removeAll()
        collectionView.reloadData()
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
        
        switch eMode {
        case .view:
            guard let photoData = viewModel.photoData(at: indexPath) else { return }
            let photoDetailVC = PhotoDetailViewController()
            photoDetailVC.diary = photoData
            navigationController?.pushViewController(photoDetailVC, animated: true)
            
        case .select:
            dictionarySelectedIndexPath[indexPath]
        }
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

