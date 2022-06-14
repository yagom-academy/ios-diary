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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mainView)
        setMainViewSetting()
        setConsantrait()
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
    
    private func setConsantrait() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setMainViewSetting() {
        loadData()
        mainView.dataSource = viewModel
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.register(MainViewCell.self, forCellReuseIdentifier: MainViewCell.identifier)
    }
}

//MARK: Navigation Method
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
        // 추가 화면 이동
    }
}
