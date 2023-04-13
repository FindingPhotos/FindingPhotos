//
//  IndicatorViewController.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/04/08.
//

import UIKit

final class IndicatorViewController: UIViewController {
    
    private lazy var appLogo: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "appLogo")
            imageView.clipsToBounds = true
            return imageView
        }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        return indicatorView
    }()
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "근처 포토부스 정보를 가져오는 중입니다...."
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .tabButtondarkGrey
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
        view.backgroundColor = .superLightGrey
        view.isOpaque = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
    }
    func setSubViews() {
        view.addSubview(appLogo)
        view.addSubview(activityIndicatorView)
        view.addSubview(guideLabel)
    }
    func setLayout() {
        
        appLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(activityIndicatorView).offset(100)
            make.width.height.equalTo(50)
        }
        
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
