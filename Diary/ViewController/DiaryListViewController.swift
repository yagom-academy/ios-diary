//
//  Diary - DiaryViewController.swift
//  Created by 리지, Goat
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private let diaryTableView: UITableView = UITableView()
    private var sampleDiary: [SampleDiary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decodeDiary()
        setupLayout()
        setupView()
        configureNavigationBar()
    }
    
    private func decodeDiary() {
        let diaryFileName = "sample"
        sampleDiary = Decoder.parseJSON(fileName: diaryFileName, returnType: [SampleDiary].self) ?? []
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(diaryTableView)
        let safeArea = view.safeAreaLayoutGuide
        
        diaryTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setupView() {
        diaryTableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        diaryTableView.dataSource = self
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc private func plusButtonTapped() {
        guard let sampleDiary = self.sampleDiary else { return }
        let diaryViewController = DiaryDetailViewController(diary: sampleDiary)
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sampleDiary = self.sampleDiary else { return 0 }
        
        return sampleDiary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let diaryCell: DiaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier) as? DiaryTableViewCell,
              let sampleDiary = self.sampleDiary else { return UITableViewCell() }
        
        diaryCell.setupItem(item: sampleDiary[indexPath.row])
        
        return diaryCell
    }
}
