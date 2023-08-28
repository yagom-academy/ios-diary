//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
//  last modified by Mary & Whales

import UIKit

class DiaryViewController: UIViewController {
    private var listCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(listCollectionView)
    }
    
    private func configureCollectionView() {
        listCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        listCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

