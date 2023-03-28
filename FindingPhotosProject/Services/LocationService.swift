//
//  LocationService.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/28.
//

import Foundation
import CoreLocation

import RxSwift

class LocationService {
    
    static let shared = LocationService()
    
    func getPlaceMark(location: CLLocation) -> Observable<String?> {
        Observable.create { observer in
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { placeMark, _ in
                observer.onNext(placeMark?.last?.thoroughfare)
            }
            return Disposables.create()
        }
    }
}
