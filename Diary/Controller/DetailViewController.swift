//
//  DetailViewController.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import UIKit

class DetailViewController: UIViewController {
    private var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    private var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    private var sampleData: DiaryModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureInitailView()
    }
    
    init(sampleData: DiaryModel? = nil) {
        self.sampleData = sampleData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureInitailView() {
        guard let item = sampleData else {
            let today = Date().timeIntervalSince1970
            let todayText = Date.convertToDate(by: Int(today))
            
            self.navigationItem.title = todayText
            
            return
        }
        
        self.navigationItem.title = Date.convertToDate(by: item.date)
        self.textField.text = item.title
        self.textView.text = item.body
    }
}
