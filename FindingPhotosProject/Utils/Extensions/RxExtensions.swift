//
//  RxExtensions.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/04/02.
//

import Foundation
import CoreLocation

import RxSwift
import RxCocoa

// MARK: - CLLocationManager Rx Extension
typealias CLLocationsEvent = (manager: CLLocationManager, locations: [CLLocation])
typealias CLErrorEvent = (manager: CLLocationManager, error: Error)

extension Reactive where Base: CLLocationManager {
    
    var delegate: RxCLLocationManagerDelegateProxy {
            return RxCLLocationManagerDelegateProxy.proxy(for: self.base)
        }
    
    var locationManagerDidChangeAuthorization: Observable<CLLocationManager> {
            return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidChangeAuthorization(_:)))
                .map { parameters in
                    return parameters[0] as! CLLocationManager
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
    var didError: ControlEvent<CLErrorEvent> {
            let generalError: Observable<CLErrorEvent> = delegate
            .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFailWithError:)))
            .map { parameters in
                return ( parameters[0] as! CLLocationManager, parameters[1] as! Error)
            }
            let updatesError: Observable<CLErrorEvent> = delegate
            .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFinishDeferredUpdatesWithError:)))
            .map { parameters in
                return ( parameters[0] as! CLLocationManager, parameters[1] as! Error)
            }
            let source = Observable.of(generalError, updatesError).merge()
            return ControlEvent(events: source)
        }
}
// MARK: - UIImagePickerController Rx Extension
extension Reactive where Base: UIImagePickerController {
    var rxDelegate: DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate> {
        return RxImagePickerDelegateProxy.proxy(for: self.base)
    }
    var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : Any]> {
        return rxDelegate
            // methodInvoked는 viewDidAppear처럼 observable이 생성된 후에 작동
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map { (parameters) in
                return parameters[1] as! [UIImagePickerController.InfoKey : Any]
            }
        
    }
    var didCancel: Observable<()> {
        return rxDelegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map { _ in ( ) }
    }
    
    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { x in }) -> Observable<UIImagePickerController> {
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe { [weak imagePicker] in
                    guard let imagePicker else { return }
                    dismissViewController(imagePicker, animated: animated)
                }
            do {
                try configureImagePicker(imagePicker)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            guard let parent else {
                observer.on(.completed)
                return Disposables.create()
            }
            parent.present(imagePicker, animated: animated)
//            parent.show(imagePicker, sender: self)
            observer.on(.next(imagePicker))
            
            return Disposables.create(dismissDisposable, Disposables.create {
                dismissViewController(imagePicker, animated: animated)
            })
        }
    }
}

func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }
        return
    }
    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated)
    }
}
