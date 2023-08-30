//
//  DetailViewController.swift
//  Diary
//
//  Created by 박종화 on 2023/08/30.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    private var sample: Sample?
    
    init?(sample: Sample, coder: NSCoder) {
        self.sample = sample
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }
    
    private func configureTextView() {
        titleTextView.text = sample?.title
        bodyTextView.text = sample?.body
    }
}
