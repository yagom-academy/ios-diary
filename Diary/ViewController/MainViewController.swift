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
    
    private let mainView = MainView()
    private let viewModel = MainViewModel()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setMainViewSetting()
        setNavigationSetting()
    }
    
    private func loadData() {
        guard let sample = NSDataAsset.init(name: "sample") else {
            return
        }
        let jsonDecoder = JSONDecoder()

        do {
            let data = try jsonDecoder.decode([DiaryData].self, from: sample.data)
            viewModel.setData(data: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setMainViewSetting() {
        loadData()
        mainView.dataSource = viewModel
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
        detailViewController.updateData(diary: DiaryData())
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
