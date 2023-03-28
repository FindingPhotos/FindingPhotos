//
//  MapViewModel.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/28.
//

import Foundation
import CoreLocation

import RxSwift
import RxCocoa


class MapViewModel: ViewModelType {
    
    struct Input {
        let locationEvent = PublishRelay<CLLocationsEvent>()
    }
    struct Output {
        let currentLocation: Observable<CLLocation>
//        let placeAddress: Observable<String?>
    }
    
    var disposeBag = DisposeBag()
    let input = Input()
    lazy var output = transform(input: input)
    
    func transform(input: Input) -> Output {
        let currentLocation = input.locationEvent
            .map { (manager: CLLocationManager, locations: [CLLocation]) in
                guard let currentIatitude = manager.location?.coordinate.latitude else {
                    return CLLocation() }
                guard let currentLongitude = manager.location?.coordinate.longitude else {
                    return CLLocation() }
                return CLLocation(latitude: currentIatitude, longitude: currentLongitude)
            }
        
        currentLocation
            .flatMap { location in
                LocationService.shared.getPlaceMark(location: location)
            }
        return Output(currentLocation: currentLocation)
    }
}
