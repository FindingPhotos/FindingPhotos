//
//  Extensions.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import UIKit
import CoreLocation

import RxSwift
import RxCocoa

extension UIColor {
    // 나누기 255 할 필요 없음, alpha값 1로 고정
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
            }
    // 메인 색상 4가지
    static let tabButtonlightGrey = UIColor(red: 0.829, green: 0.819, blue: 0.819, alpha: 1)
    static let tabButtondarkGrey = UIColor(red: 0.287, green: 0.287, blue: 0.287, alpha: 1)
    static let darked = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
    static let buttonYellow = UIColor(red: 0.962, green: 0.837, blue: 0.393, alpha: 1)
}

extension ViewModelBindable where Self: UIViewController {
    func bind(viewModel: ViewModel) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}

typealias CLLocationsEvent = (manager: CLLocationManager, locations: [CLLocation])

extension Reactive where Base: CLLocationManager {
    var delegate: RxCLLocationManagerDelegateProxy {
            return RxCLLocationManagerDelegateProxy.proxy(for: self.base)
        }
    
    var locationManagerDidChangeAuthorization: Observable<CLLocationManager> {
        if #available(iOS 14.0, *) {
            return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidChangeAuthorization(_:)))
                .map { parameters in
                    return parameters[0] as! CLLocationManager
                }
        } else {
            return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
                .map { parameters in
                    return parameters[0] as! CLLocationManager
                }
        }
    }
    var didUpdateLocations: ControlEvent<CLLocationsEvent> {
            let source: Observable<CLLocationsEvent> = delegate
                .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
                .map { parameters in
                    let manager = parameters[0] as! CLLocationManager
                    let locations = parameters[1] as! [CLLocation]
                    let event: CLLocationsEvent = (manager, locations)
                    return event
                }
            return ControlEvent(events: source)
        }
}
