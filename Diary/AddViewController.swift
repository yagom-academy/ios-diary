//
//  AddViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

final class AddViewController: UIViewController {
    private let addView = AddDiaryView()
    private let coreDataManager = CoreDataManager.shared
    private let currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addView
        setNavigation()
    }
    
    private func setNavigation() {
        let date = Formatter.changeCustomDate(currentDate)
        self.title = date
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                 target: self,
                                                 action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func doneButtonTapped() {
        let data = addView.packageData()
        switch data {
        case .success(let data):
            coreDataManager.saveData(data: (title: data.title,
                                            body: data.body,
                                            createdAt: currentDate),
                                     completion: {
                self.showCustomAlert(alertText: "저장 성공",
                                     alertMessage: "저장성공하였습니다.",
                                     bool: true) {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        case .failure(let error):
            self.showCustomAlert(alertText: "저장 실패하였습니다.",
                                 alertMessage: error.errorDescription ?? "",
                                 bool: false,
                                 completion: nil)
        }
    }
}
