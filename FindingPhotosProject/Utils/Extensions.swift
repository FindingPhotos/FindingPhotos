//
//  Extensions.swift
//  FindingPhotosProject
//
//  Created by 이형주 on 2023/03/23.
//

import UIKit
import SafariServices
import MessageUI
import RxSwift
import RxCocoa
import CoreLocation

// MARK: - UIColor Extension
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
    static let superLightGrey = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
}
// MARK: - String Extension
extension String {
    // html 태그 제거 + html entity들 디코딩.
    var htmlEscaped: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributed = try NSAttributedString(data: encodedData,
                                                    options: options,
                                                    documentAttributes: nil)
            return attributed.string
        } catch {
            return self
        }
    }
}

// MARK: - ViewModelBindable Extension
extension ViewModelBindable where Self: UIViewController {
    func bind(viewModel: ViewModel) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}

extension UIViewController {
    func openSFSafari(url: String) {
        guard let url = URL(string: url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}


extension MFMailComposeViewControllerDelegate {
    
    func sendEmail(self: UIViewController, _ completion: () -> Void) {
           if MFMailComposeViewController.canSendMail() {
               let compseVC = MFMailComposeViewController()
               compseVC.mailComposeDelegate = (self as! any MFMailComposeViewControllerDelegate)
               compseVC.setToRecipients(["leehyungju20@gmail.com"])
               compseVC.setSubject("'FindingPhotos' 문의")
//               compseVC.setMessageBody("문의계정: \(userEmail)\n문의하실 내용을 입력하세요.", isHTML: false)
               compseVC.setMessageBody("문의하실 내용을 입력하세요.", isHTML: false)
               self.present(compseVC, animated: true, completion: nil)
               completion()
           }
           else {
               self.showAlert("메일을 전송 실패", "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", nil)
           }
       }
}

extension UIViewController {
    func showAlert(_ title: String, _ message: String, _ okAction: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "취소", style: .cancel))
        if let okAction {
            let ok = UIAlertAction(title: "확인", style: .default){ _ in
                okAction()
            }
            alertVC.addAction(ok)
        }
        present(alertVC, animated: true, completion: nil)
        
    }
}

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

extension Reactive where Base: UIImagePickerController {
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

// MARK: - Reactive Extension
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
