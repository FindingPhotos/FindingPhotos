//
//  RxDelegateProxy.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/27.
//

import UIKit
import CoreLocation

import RxSwift
import RxCocoa

class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    static func registerKnownImplementations() {
        self.register { CLLocationManager -> RxCLLocationManagerDelegateProxy in
            RxCLLocationManagerDelegateProxy(parentObject: CLLocationManager, delegateProxy: self)
        }
    }
    static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        object.delegate
    }
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
}
