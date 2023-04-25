//
//  Diary - HomeDiaryController.swift
//  Created by Andrew, Brody.
// 

import UIKit

final class HomeDiaryController: UIViewController {
    private let diaryTableView = UITableView()
    private var diaries: [DiaryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryTableView.dataSource = self
        diaryTableView.register(DiaryCell.self, forCellReuseIdentifier: "cell")
        configureUI()
        let jsonData = loadJsonAsset(name: "sample")
        decode(jsonData)
        
    }

    private func loadJsonAsset(name: String) -> Data? {
        guard let asset = NSDataAsset(name: name) else {
            return nil
        }
        return asset.data
    }
    
    private func decode(_ jsonData: Data?) {
        guard let jsonData else {
            return
        }
        do {
            diaries = try JSONDecoder().decode([DiaryItem].self, from: jsonData)
            diaryTableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        diaryTableView.rowHeight = UITableView.automaticDimension
        diaryTableView.estimatedRowHeight = 600
        
        view.addSubview(diaryTableView)
        diaryTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: view.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddDiaryButton))
    }
    
    @objc private func didTapAddDiaryButton() {
        
    }
    
}

extension HomeDiaryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DiaryCell else {
            return UITableViewCell()
        }
        
        cell.configureData(data: diaries[indexPath.row])
        
        return cell
    }
}
