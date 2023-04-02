//
//  UIViewController.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/04/02.
//

import UIKit
import SafariServices
import MessageUI

extension UIViewController {
    func openSFSafari(url: String) {
        guard let url = URL(string: url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
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
