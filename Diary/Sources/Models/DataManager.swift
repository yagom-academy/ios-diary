//
//  DataManager.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/09/01.
//

import UIKit

class DataManager {
    static let shared = DataManager()
    
    var dataSource: UITableViewDiffableDataSource<Section, DiaryContents>?
    var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryContents>()

    private init() { }
}
