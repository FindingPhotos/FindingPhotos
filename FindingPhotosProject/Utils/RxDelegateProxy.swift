//
//  RxDelegateProxy.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/28.
//
import UIKit
import CoreLocation
import RxSwift
import RxCocoa

final class RxImagePickerDelegateProxy: DelegateProxy<UIImagePickerController, UINavigationControllerDelegate & UIImagePickerControllerDelegate>,
                                        DelegateProxyType, UINavigationControllerDelegate & UIImagePickerControllerDelegate {
    
    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?,
                                   to object: UIImagePickerController) {
        object.delegate = delegate
    }
    
    static func registerKnownImplementations() {
        //        self.register { RxImagePickerDelegateProxy(parentObject: $0,
        //                                                   delegateProxy: RxImagePickerDelegateProxy.self) }
        self.register { (imagePicker) -> RxImagePickerDelegateProxy in
            RxImagePickerDelegateProxy(parentObject: imagePicker, delegateProxy: self)
        }
    }
}

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
