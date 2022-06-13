//
//  Diary - DiaryListViewController.swift
//  Created by safari, Eddy.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

private enum Section {
    case main
}

final class DiaryListViewController: UITableViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Section, Diary>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Diary>
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
