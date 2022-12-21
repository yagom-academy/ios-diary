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
    }
    
    func configureView() {
        guard let data = diaryData else { return }
        self.navigationItem.title = data.createdAt.convertDate()
        self.detailTextView.text = "\(data.title)\n\n\(data.body)"
    }

}
