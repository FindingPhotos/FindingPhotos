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

final class MapViewController: UIViewController, ViewModelBindable {
    // MARK: - Properties
    
    var viewModel: MapViewModel!
    var disposeBag = DisposeBag()
    
    private lazy var mapView: NMFMapView = {
        let mapView = NMFMapView(frame: view.frame)
        mapView.positionMode = .direction
        return mapView
    }()
    private var locationManager: CLLocationManager!
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        setSubViews()
        setLayout()
    }
    // MARK: - helpers
    func bindViewModel() {
        if #available(iOS 14.0, *) {
            locationManager.rx.locationManagerDidChangeAuthorization
                .withUnretained(self)
                .bind { mapViewController, locationManager in
                    locationManager.startUpdatingLocation()
                }
                .disposed(by: disposeBag)
        }
        // MARK: - ViewModel Input
        locationManager.rx.didUpdateLocations
            .bind(to: viewModel.input.locationEvent)
            .disposed(by: disposeBag)
        // MARK: - ViewModel Output
        viewModel.output.currentLocation
            .withUnretained(self)
            .bind { mapViewController ,location in
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude))
                cameraUpdate.animation = .easeIn
                
                mapViewController.mapView.moveCamera(cameraUpdate)
                let marker = NMFMarker(position: NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude))
                marker.mapView = mapViewController.mapView
            }
            .disposed(by: disposeBag)
    }
}
// MARK: - LayoutProtocol
extension MapViewController: LayoutProtocol {
    func setValue() {
        view.backgroundColor = .white
        navigationItem.title = "근처 사진관 찾기"
        locationManager = CLLocationManager()
    }
    func setSubViews() {
        view.addSubview(mapView)
    }
    func setLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
