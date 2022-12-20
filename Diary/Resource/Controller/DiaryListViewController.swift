//
//  DiaryListViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

class DiaryListViewController: UIViewController {
    private let diaryListTableView = UITableView()
    private var diaryForms: [DiaryForm] = []

    // TODO: 함수 정리
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureJSONData()
        configureNavigationBar()
        self.view = diaryListTableView
        self.diaryListTableView.delegate = self
        self.diaryListTableView.dataSource = self
    }
    
    // TODO: 디코딩 실패 시 얼럿 구현
    private func configureJSONData() {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "sample") else { return }
        
        do {
            diaryForms = try jsonDecoder.decode([DiaryForm].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        
        self.diaryListTableView.reloadData()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        self.title = "일기장"
        let rightBarButtonImage = UIImage(systemName: "plus")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tappedPlusButton))
    }
    
    // TODO: 일기장 생성 화면으로 이동
    @objc private func tappedPlusButton(_ sender: UIBarButtonItem) {
        
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryForms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.diaryListTableView.register(DiaryListTableViewCell.self,
                                         forCellReuseIdentifier: DiaryListTableViewCell.identifier)
        
        guard let cell = diaryListTableView.dequeueReusableCell(
            withIdentifier: DiaryListTableViewCell.identifier,
            for: indexPath
        ) as? DiaryListTableViewCell else { return UITableViewCell() }
        
        cell.diaryForm = diaryForms[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate { }

