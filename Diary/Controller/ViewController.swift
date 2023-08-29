//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        guard let asset = NSDataAsset(name: "sample") else { return }
        let decoder = JSONDecoder()        
        if let diaries = try? decoder.decode([Diary].self, from: asset.data) {
            print(diaries)
        }
    }

}
