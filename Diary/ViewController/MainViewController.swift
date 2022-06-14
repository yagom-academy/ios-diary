//
//  Diary - MainViewController.swift
//  Created by 우롱차, RED on 2022/06/14.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    private lazy var mainView = MainView()
    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        view.backgroundColor = .white
        mainView.dataSource = viewModel
        mainView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainView)
        mainView.register(MainViewCell.self, forCellReuseIdentifier: MainViewCell.identifier)
        setConsantrait()
        mainView.reloadData()

    }
    
    func loadData() {
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
    
    func setConsantrait() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
