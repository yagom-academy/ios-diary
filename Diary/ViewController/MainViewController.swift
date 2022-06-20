//
//  Diary - MainViewController.swift
//  Created by 우롱차, RED on 2022/06/14.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    private enum Constnat {
        static let navigationTitle = "일기장"
    }
    
    private var mainView: UITableView
    private var viewModel: MainViewModel
    
    init(view: UITableView, viewModel: MainViewModel) {
        self.mainView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setMainViewSetting()
        setNavigationSetting()
    }
    
    private func setMainViewSetting() {
        viewModel.loadData()
        mainView.dataSource = self
        mainView.delegate = self
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.register(MainViewCell.self, forCellReuseIdentifier: MainViewCell.identifier)
    }
}

// MARK: Navigation Method
extension MainViewController {
    private func setNavigationSetting() {
        navigationItem.title = Constnat.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(rightBarbuttonClicked(_:))
        )
    }
    
    @objc
    private func rightBarbuttonClicked(_ sender: Any) {
        let detailViewController = DetailViewController()
        //추후 수정
        detailViewController.updateData(diary: DiaryInfo(title: "", body: "", date: nil, key: nil))
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: tableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.updateData(diary: viewModel.data[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewCell.identifier, for: indexPath
        ) as? MainViewCell else {
            return MainViewCell()
        }
        cell.setDiaryData(viewModel.data[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
}

