//
//  MapViewModel.swift
//  FindingPhotosProject5

//
//  Created by 강창혁 on 2023/03/28.
//

import Foundation
import CoreLocation

import NMapsMap
import RealmSwift

import RxSwift
import RxCocoa


final class MapViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear = BehaviorRelay<Bool>(value: false)
        let faviorateButtonTapped = PublishRelay<StudioInformation>()
        let studioNameLabelText = PublishRelay<String>()
    }
    struct Output {
        let marker: Observable<NMFMarker>
        let deinied: Observable<CLLocationManager>
        let didError: ControlEvent<CLErrorEvent>
        let faviorateButtonImage: BehaviorRelay<UIImage?>
    }
    
    var disposeBag = DisposeBag()
    let input = Input()
    lazy var output = transform(input: input)
    
    func transform(input: Input) -> Output {
        
        let manager = input.viewWillAppear
            .flatMap { _ in
                LocationManager.shared.locationManager.rx.locationManagerDidChangeAuthorization
            }
        manager.filter { return $0.authorizationStatus == .notDetermined}
            .subscribe(onNext: { manager in
                manager.requestWhenInUseAuthorization()
            })
            .disposed(by: disposeBag)
        manager.filter { return $0.authorizationStatus == .authorizedWhenInUse }
            .subscribe(onNext: { manager in
                manager.requestLocation()
            })
            .disposed(by: disposeBag)
        let denied = manager.filter { return $0.authorizationStatus == .denied }
        
        let didError = LocationManager.shared.locationManager.rx.didError
        
        let marker = LocationManager.shared.locationManager.rx.didUpdateLocations
            .map { (manager: CLLocationManager, locations: [CLLocation]) in
                guard let currentIatitude = manager.location?.coordinate.latitude else {
                    return CLLocation() }
                guard let currentLongitude = manager.location?.coordinate.longitude else {
                    return CLLocation() }
                return CLLocation(latitude: currentIatitude, longitude: currentLongitude)
            }
            .flatMap { location in
                LocationManager.shared.getPlaceMark(location: location)
            }
            .flatMap { currentAddress in
                LocationManager.shared.getPhthoStudios(currentAddress: currentAddress)
            }
            .flatMap { photoStudios in
                Observable.from(photoStudios.items, scheduler: ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            }
            .map { photoStudio in
                let photoStudioLocation = NMGTm128(x: Double(photoStudio.mapx)!, y: Double(photoStudio.mapy)!).toLatLng()
                let marker = NMFMarker(position: photoStudioLocation)
                marker.captionText = photoStudio.title.htmlEscaped
                marker.captionRequestedWidth = 0
                marker.captionTextSize = 13
                marker.userInfo["studioInformation"] = photoStudio
                let distance = LocationManager.shared.locationManager.location?.distance(from: CLLocation(latitude: photoStudioLocation.lat, longitude: photoStudioLocation.lng))
                marker.userInfo["distance"] = distance
                marker.userInfo["currentPosition"] = photoStudioLocation
                return marker
            }
        
        let buttonImage = BehaviorRelay<UIImage?>(value: nil)
        
        input.studioNameLabelText
            .map { studioName in
                RealmManager.shared.realm.objects(PhotoStudio.self).filter { return $0.title == studioName }.isEmpty
            }
            .map { result in
                guard result else { return UIImage(named: "likeButton")}
                return UIImage(named: "initialButton")
            }
            .bind(to: buttonImage)
            .disposed(by: disposeBag)
        input.faviorateButtonTapped
            .subscribe(onNext: { studioName, studioAddress in
                let realm = try! Realm()
                let studio = PhotoStudio(name: studioName ?? "", address: studioAddress ?? "")
                try! realm.write({
                    let savedData = realm.objects(PhotoStudio.self).filter { return $0.title == studio.title }
                    if savedData.isEmpty {
                        realm.add(studio)
                        buttonImage.accept(UIImage(named: "likeButton"))
                    } else {
                        realm.delete(savedData)
                        buttonImage.accept(UIImage(named: "initialButton"))
                    }
                })
            })
            .disposed(by: disposeBag)
        
        
        
        return Output(marker: marker,
                      deinied: denied,
                      didError: didError,
                      faviorateButtonImage: buttonImage)
    }
    func presentLocationPermissionAlertController() -> UIAlertController {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let settingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let appSetting = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(appSetting)
        }
        alert.addAction(cancel)
        alert.addAction(settingAction)
        
        return alert
    }
}
