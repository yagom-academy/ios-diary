//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private let mainDiaryView = MainDiaryView()
    private var diaries: [Diary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainDiaryView
        configureNavigationItem()
        setUpTableView()
        decodeDiaryData()
    }
    
    private func setUpTableView() {
        mainDiaryView.diaryTableView.dataSource = self
    }
    
    private func decodeDiaryData() {
        guard let dataAsset = NSDataAsset(name: NameSpace.assetName) else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            diaries = try decoder.decode([Diary].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func configureNavigationItem() {
        navigationItem.title = NameSpace.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addDiary))
    }

    @objc private func addDiary() {
        navigationController?.pushViewController(DiaryFormViewController(), animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CustomDiaryCell = tableView.dequeueReusableCell(
            withIdentifier: CustomDiaryCell.identifier,
            for: indexPath
        ) as? CustomDiaryCell else {
            return UITableViewCell()
        }
        
        let diary = diaries[indexPath.row]
        
        cell.configureCell(with: diary)
        
        return cell
    }
}

// MARK: - NameSpace
private enum NameSpace {
    static let navigationTitle = "일기장"
    static let assetName = "sample"
}
