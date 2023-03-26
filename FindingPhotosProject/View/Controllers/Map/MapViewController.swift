//
//  MapViewController.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import UIKit
import NMapsMap
import SnapKit

final class MapViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var mapView: NMFNaverMapView = {
        let mapView = NMFNaverMapView(frame: view.frame)
        mapView.showZoomControls = false
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
}

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
            make.top.equalToSuperview().offset(100)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
