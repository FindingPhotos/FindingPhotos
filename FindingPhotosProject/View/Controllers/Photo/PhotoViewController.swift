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
    var realmManager = RealmManager()
    var selectedIndexes = [IndexPath]()
        
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
    
    lazy var deleteBarButton : UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "deletedButtonGrey")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didDeleteButtonClicked), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
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
                let selectButton = UIButton(type: .custom)
                selectButton.setImage(UIImage(named: "canceledButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
                selectButton.addTarget(self, action: #selector(didCanceledButtonClicked), for: .touchUpInside)
                let selectBarButtonItem = UIBarButtonItem(customView: selectButton)
                
                let addButton = UIButton(type: .custom)
                addButton.setImage(UIImage(named: "deletedButtonDisabled")?.withRenderingMode(.alwaysOriginal), for: .normal)
                addButton.addTarget(self, action: #selector(didDeleteButtonClicked), for: .touchUpInside)
                let addBarButtonItem = UIBarButtonItem(customView: addButton)
                
                navigationItem.rightBarButtonItems = [addBarButtonItem, selectBarButtonItem]
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
        collectionView.reloadData()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    
    
    
    // MARK: - Selectors
    
    @objc func addButtonTapped(_ sender: Any) {
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
        updateViewWithButtons()
    }
    
    
    @objc func didDeleteButtonClicked(_ sender: UIBarButtonItem) {
        
        // 선택된 사진이 없으면 실행하지 않음
        guard !dictionarySelectedIndexPath.isEmpty else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [self] _ in
            
            var deleteNeededIndexPaths: [IndexPath] = []

            for (key, value) in self.dictionarySelectedIndexPath {
                if value {
                    deleteNeededIndexPaths.append(key)
                }
            }
            // realm 데이터 삭제
            for indexPath in deleteNeededIndexPaths.sorted(by: { $0.item > $1.item }) {
                guard let photoData = self.viewModel.photoData(at: indexPath) else { return }
                self.realmManager.delete(photoData: photoData)
            }
            

            // colletionViewCell 삭제
            self.collectionView.deleteItems(at: deleteNeededIndexPaths)
            self.dictionarySelectedIndexPath.removeAll()
            self.collectionView.reloadData()
            
            // 선택 모드 해제
            updateViewWithButtons()
            
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
        
        let imageView = UIImageView(image: UIImage(named: "titleImage"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "addButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)
        
        let selectButton = UIButton(type: .custom)
        selectButton.setImage(UIImage(named: "selectedButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectButton.addTarget(self, action: #selector(didSelectButtonClicked), for: .touchUpInside)
        let selectBarButtonItem = UIBarButtonItem(customView: selectButton)
        
        navigationItem.rightBarButtonItems = [addBarButtonItem, selectBarButtonItem]
        let spacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacing.width = -10 // 원하는 간격 설정
        navigationItem.rightBarButtonItems?.append(spacing)
        
    }
    
    private func updateViewWithButtons() {
        eMode = .view
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "addButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let addBarButtonItem = UIBarButtonItem(customView: addButton)
        
        let selectButton = UIButton(type: .custom)
        selectButton.setImage(UIImage(named: "selectedButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectButton.addTarget(self, action: #selector(didSelectButtonClicked), for: .touchUpInside)
        let selectBarButtonItem = UIBarButtonItem(customView: selectButton)
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 10
        
        navigationItem.rightBarButtonItems = [addBarButtonItem, space, selectBarButtonItem]
        
        collectionView.alpha = 1.0
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
            updateViewWithButtons()
            navigationController?.pushViewController(photoDetailVC, animated: true)
            
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.dictionarySelectedIndexPath[indexPath] = false // 선택을 해제한 셀의 IndexPath를 딕셔너리에서 제거
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

