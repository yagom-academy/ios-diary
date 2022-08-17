//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/17.
//

import UIKit

class DiaryDetailViewController: UIViewController {

    var delegate: DataSendable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

extension DiaryDetailViewController: DataSendable {
    func setupData<T>(_ data: T) {
        guard let abc = data as? JSONModel else { return }
        print(abc)
    }
}
