//
//  RxDelegateProxy.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/28.
//

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
