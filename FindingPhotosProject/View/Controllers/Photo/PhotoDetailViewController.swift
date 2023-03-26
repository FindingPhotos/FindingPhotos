//
//  PhotoDetailViewController.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/26.
//

import UIKit
import SnapKit

class PhotoDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        textField.text = ""
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height - 100)
        return textField
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: 200))
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 5.0
        
        datePicker.addTarget(self, action: #selector(onDidChangeDate(sender:)), for: .valueChanged)
        return datePicker
    }()
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigation()
        configureNavigation()
        
        self.view.addSubview(self.textField)
        self.view.addSubview(self.datePicker)
    }
    
    // MARK: - Selectors
    
    @objc func saveButtonTapped(_ sender: Any) {
        print("사진 저장")
    }
    
    @objc func onDidChangeDate(sender: UIDatePicker) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
        
        // 형식에 따라 날짜 가져오기
        let selectedDate: String = dateFormatter.string(from: sender.date)
        self.textField.text = selectedDate
    }
    
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureNavigation() {
        let rightButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureDataPicker() {
        self.view.addSubview(self.datePicker)
    }
    
}
