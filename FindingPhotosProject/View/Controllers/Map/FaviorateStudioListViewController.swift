//
//  FaviorateStudioListViewController.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/31.
//

import UIKit

import RxSwift

final class FaviorateStudioListViewController: UIViewController, ViewModelBindable {
    // MARK: - Properties
    var viewModel: FaviorateStudioListViewModel!
    var disposeBag = DisposeBag()
    private let faviorateStudioListTableView: UITableView = {
        let listTableView = UITableView()
        listTableView.register(FaviorateStudioListTableViewCell.self, forCellReuseIdentifier: FaviorateStudioListTableViewCell.cellIdentifier)
        return listTableView
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        setValue()
        setSubViews()
        setLayout()
    }
    // MARK: - bindViewModel
    func bindViewModel() {
        rx.viewWillAppear
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)
        viewModel.output.photoStudios
            .subscribe(onNext: { photoStudio in
                photoStudio.forEach { studio in
                    print(studio)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension FaviorateStudioListViewController: LayoutProtocol {
    func setValue() {
        view.backgroundColor = .white
        navigationItem.title = "즐겨찾는 사진관"
    }
    func setSubViews() {
        
    }
    func setLayout() {
        
    }
}
