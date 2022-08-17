//
//  MainViewController.swift
//  Diary
//
//  Created by Kiwi, Brad on 2022/08/16.
//

import UIKit

class MainViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.navigationController?.navigationBar.topItem?.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didAddDiaryButtonTapped))
    }
    
    @objc func didAddDiaryButtonTapped() {
    }
}
