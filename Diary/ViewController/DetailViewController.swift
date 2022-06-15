//
//  DetailViewController.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

final class DetailViewController: UIViewController {
    lazy var detailView = DetailView(frame: view.frame)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
    }
    
}
