//
//  DetailViewController.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
    

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTextView: UITextView!
    var diaryData: SampleData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addNotificationObserver()
    }
    
    func configureView() {
        guard let data = diaryData else { return }
        self.navigationItem.title = data.createdAt.convertDate()
        self.detailTextView.text = "\(data.title)\n\n\(data.body)"
    }
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_ :)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_ :)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc
    func keyboardWillShow(_ notification: Notification) {
        
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        
    }
}
