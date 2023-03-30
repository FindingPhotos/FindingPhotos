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

final class MapViewController: UIViewController, ViewModelBindable {
    // MARK: - Properties
    
    var viewModel: MapViewModel!
    var disposeBag = DisposeBag()
    
    private lazy var mapView: NMFMapView = {
        let mapView = NMFMapView(frame: view.frame)
        mapView.positionMode = .direction
        return mapView
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
        viewModel.output.marker
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { mapViewController, marker in
                marker.mapView = mapViewController.mapView
                marker.touchHandler = { [weak self] overlay -> Bool in
                    guard let studioInformation = marker.userInfo["studioInformation"] as? Item else { return false }
                    self?.studioInformationView.bind(item: studioInformation)
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
    }
}
// MARK: - LayoutProtocol
extension MapViewController: LayoutProtocol {
    func setValue() {
        view.backgroundColor = .white
        navigationItem.title = "근처 사진관 찾기"
    }
    func setSubViews() {
        view.addSubview(mapView)
        view.addSubview(studioInformationView)
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
    }
}
