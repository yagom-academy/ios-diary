//
//  Diary - ViewController.swift
//  Created by rilla, songjun.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureUI() {
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        
    }
}
