//
//  NewDiaryViewController.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/21.
//

import UIKit

final class NewDiaryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        configureNavigation()
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    private func configureNavigation() {
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        
        navigationItem.title = Date().localeFormattedText
        navigationItem.leftBarButtonItem = cancelButton
    }
}
