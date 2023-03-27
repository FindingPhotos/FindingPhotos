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
import RxCoreLocation

final class MapViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var mapView: NMFNaverMapView = {
        let mapView = NMFNaverMapView(frame: view.frame)
        mapView.positionMode = .direction
        mapView.showLocationButton = true
        return mapView
    }()
    private var locationManager: CLLocationManager!
    var disposeBag = DisposeBag()
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        setSubViews()
        setLayout()
        
    }
    // MARK: - helpers
}
// MARK: - LayoutProtocol
extension MapViewController: LayoutProtocol {
    func setValue() {
        view.backgroundColor = .white
        navigationItem.title = "근처 사진관 찾기"
        locationManager = CLLocationManager()
        
        locationManager.rx.didChangeAuthorization
            .subscribe(onNext: { event in
                print(event.status)
            })
            .disposed(by: disposeBag)
        
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

extension MapViewController: CLLocationManagerDelegate {
    //ios 14 이상 버전 대응
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                print("위치 사용권한을 선택하지 않은 경우")
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("앱이 위치 사용 권한이 없음")
            case .denied:
                print("사용자가 시스템 설정에서 위치 사용 할수 없도록 설정")
                let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
            
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                let settingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                    guard let appSetting = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(appSetting)
                }
                
                alert.addAction(cancel)
                alert.addAction(settingAction)
                
                self.present(alert, animated: true, completion: nil)
            case .authorizedAlways:
                print("사용자 위치 항상 사용 가능")
            case .authorizedWhenInUse:
                print("앱 실행중에만 사용자 위치 사용 가능")
            default:
                break
            }
        }
    }
    // iOS 13 버전 대응
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("위치 사용권한을 선택하지 않은 경우")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("앱이 위치 사용 권한이 없음")
        case .denied:
            print("사용자가 시스템 설정에서 위치 사용 할수 없도록 설정")
        case .authorizedAlways:
            print("사용자 위치 항상 사용 가능")
        case .authorizedWhenInUse:
            print("앱 실행중에만 사용자 위치 사용 가능")
        default:
            break
        }
    }
}

