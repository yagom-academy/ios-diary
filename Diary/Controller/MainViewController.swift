//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private lazy var mainView = MainView(frame: view.bounds)

    private let parser = JSONDecoder()
    private var diary: [Diary]?
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.baseTableView.dataSource = self
        diary = try? parser.decode([Diary].self, from: NSDataAsset(name: "sample")!.data)
    }
}
    }
}
