//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/17.
//

import UIKit

final class AddDiaryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.title = fetchCurrentDate()
    }
    
    private func fetchCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
}
