//
//  MapViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import UIKit
import CoreLocation

import NMapsMap
import SnapKit

import RxSwift
import RxViewController
import RxGesture
import RealmSwift

final class MapViewController: UIViewController, ViewModelBindable {
    // MARK: - Properties
    
    var viewModel: MapViewModel!
    var disposeBag = DisposeBag()
    
    private lazy var mapView: NMFMapView = {
        let mapView = NMFMapView(frame: view.frame)
        mapView.positionMode = .direction
        return mapView
    }()
    private let favoriteListButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("즐겨찾기한 사진관", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 4
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        return button
    }()
    private let studioInformationView = StudioInformationView()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        setSubViews()
        setLayout()
    }
    // MARK: - helpers
    func bindViewModel() {
        // MARK: - ViewModel Input
        rx.viewWillAppear
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)
        // MARK: - ViewModel Output
        viewModel.output.currentPosition
            .withUnretained(self)
            .bind { mapViewController, currentPosition in
                let position = NMGLatLng(lat: currentPosition.coordinate.latitude, lng: currentPosition.coordinate.longitude)
                let cameraUpdate = NMFCameraUpdate(scrollTo: position)
                mapViewController.mapView.locationOverlay.hidden = false
                mapViewController.mapView.moveCamera(cameraUpdate)
                mapViewController.mapView.locationOverlay.location = position
            }
            .disposed(by: disposeBag)
        viewModel.output.marker
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { mapViewController, marker in
                marker.mapView = mapViewController.mapView
                marker.touchHandler = { overlay -> Bool in
                    guard let studioInformation = marker.userInfo["studioInformation"] as? Item else { return false }
                    guard let currentPosition = marker.userInfo["currentPosition"] as? NMGLatLng else { return false }
                    guard let distance = marker.userInfo["distance"] as? Double else { return false }
                    let cameraUpdate = NMFCameraUpdate(scrollTo: currentPosition)
                    mapViewController.mapView.moveCamera(cameraUpdate)
                    mapViewController.studioInformationView.disposeBag = DisposeBag()
                    mapViewController.studioInformationView.bind(item: studioInformation, distance: distance, viewModel: mapViewController.viewModel)
                    return true
                }
            })
            .disposed(by: disposeBag)
        viewModel.output.deinied
            .withUnretained(self)
            .bind(onNext: { mapViewController, _ in
                let alertController = mapViewController.viewModel.presentLocationPermissionAlertController()
                mapViewController.present(alertController, animated: true)
            })
            .disposed(by: disposeBag)
        viewModel.output.didError
            .bind { event in
                print(event.error.localizedDescription)
            }
            .disposed(by: disposeBag)
        favoriteListButton.rx.tap
            .withUnretained(self)
            .bind { mapViewController, _ in
                let faviorateStudioListViewModel = FaviorateStudioListViewModel()
                let faviorateStudioListViewController = FaviorateStudioListViewController()
                mapViewController.navigationController?.pushViewController(faviorateStudioListViewController, animated: true)
                faviorateStudioListViewController.bind(viewModel: faviorateStudioListViewModel)
            }
            .disposed(by: disposeBag)
        mapView.rx.swipeGesture(.right, .left, .down, .up)
            .when(.recognized)
            .map { _ in return true }
            .bind(to: studioInformationView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
// MARK: - LayoutProtocol
extension MapViewController: LayoutProtocol {
    func setValue() {
        view.backgroundColor = .white
        navigationItem.title = "근처 사진관 찾기"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonTitle = ""
    }
    func setSubViews() {
        view.addSubview(mapView)
        view.addSubview(studioInformationView)
        view.addSubview(favoriteListButton)
    }
    func setLayout() {
        mapView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        studioInformationView.snp.makeConstraints { make in
            make.bottom.equalTo(mapView.snp.bottom)
            make.size.equalTo(CGSize(width: view.frame.width, height: 70))
        }
        favoriteListButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.top).offset(10)
            make.right.equalTo(mapView.snp.right).offset(-10)
            make.size.equalTo(CGSize(width: view.frame.width * 0.3, height: view.frame.height * 0.04))
        }
    }
}
