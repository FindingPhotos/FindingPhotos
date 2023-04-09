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
    private lazy var faviorateStudioListTableView: UITableView = {
        let listTableView = UITableView()
        listTableView.register(FaviorateStudioListTableViewCell.self, forCellReuseIdentifier: FaviorateStudioListTableViewCell.cellIdentifier)
        listTableView.rowHeight = self.view.frame.height * 0.1
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
            .bind(to: faviorateStudioListTableView.rx.items(cellIdentifier: FaviorateStudioListTableViewCell.cellIdentifier, cellType: FaviorateStudioListTableViewCell.self)) { [weak self] row, photoStudio, cell in
                guard let faviorateStudioListViewController = self else { return }
                cell.bind(photoStudio: photoStudio, viewModel: faviorateStudioListViewController.viewModel, row: row)
            }
            .disposed(by: disposeBag)
    }
}

extension FaviorateStudioListViewController: LayoutProtocol {
    func setValue() {
        view.backgroundColor = .white
        navigationItem.title = "즐겨찾는 사진관"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func setSubViews() {
        view.addSubview(faviorateStudioListTableView)
    }
    func setLayout() {
        faviorateStudioListTableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaInsets)
        }
    }
}
