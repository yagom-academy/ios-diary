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
        
        let decodedResult = DecodeManager().decodeJSON(fileName: "sample", type: Diaries.self)
        let data = try? verifyResult(result: decodedResult)
        
        configureUI()
        configureLayout()
        configureViewController()
    }
    
    private func verifyResult<T, E: Error>(result: Result<T, E>) throws -> T? {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    private func configureUI() {
        //view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        
    }
    
    private func configureViewController() {
        view.backgroundColor = .white
        self.title = "일기장"

        let buttonItem: UIBarButtonItem = {
            let button = UIButton()
            
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.addTarget(self,
                             action: #selector(presentCellChangeActionSheet),
                             for: .touchUpInside)
            let barButton = UIBarButtonItem(customView: button)
            
            return barButton
        }()
        
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc private func presentCellChangeActionSheet() {
   
    }
    
}
