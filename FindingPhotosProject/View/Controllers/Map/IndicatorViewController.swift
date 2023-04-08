//
//  IndicatorViewController.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/04/08.
//

import UIKit

final class IndicatorViewController: UIViewController {
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        return indicatorView
    }()
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = " 근처 포토부스 정보를 가져오는 중입니다...."
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        setSubViews()
        setLayout()
    }
}
// MARK: - LayoutProtocol
extension IndicatorViewController: LayoutProtocol {
    func setValue() {
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.isOpaque = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
    }
    func setSubViews() {
        view.addSubview(activityIndicatorView)
        view.addSubview(guideLabel)
    }
    func setLayout() {
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: view.frame.width * 0.4, height: view.frame.width * 0.4))
        }
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicatorView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
}
