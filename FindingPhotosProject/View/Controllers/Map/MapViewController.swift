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
        viewModel.output.photoStudios
            .flatMap { photoStudios in
                Observable.from(photoStudios.items, scheduler: ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            }
            .map { item in
                NMFMarker(position: NMGTm128(x: Double(item.mapx)!, y: Double(item.mapy)!).toLatLng())
            }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { mapViewController, marker in
                marker.mapView = mapViewController.mapView
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
    }
    func setLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
