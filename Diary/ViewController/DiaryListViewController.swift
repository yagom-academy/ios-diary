//
//  Diary - DiaryViewController.swift
//  Created by 리지, Goat
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private let diaryTableView: UITableView = UITableView()
    private var myDiary: [DiaryCoreData]?
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupLayout()
        setupView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMyDiary()
        diaryTableView.reloadData()
    }
    
    private func setupMyDiary() {
        guard let diary = CoreDataManager.shared.readAll() else { return }
        self.myDiary = diary
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
        diaryTableView.delegate = self
    }
    
    private func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc private func plusButtonTapped() {
        let diaryDetailViewController = DiaryDetailViewController(fetchedDiary: nil, mode: .create)
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sampleDiary = self.myDiary else { return 0 }
        
        return sampleDiary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let diaryCell: DiaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier) as? DiaryTableViewCell,
              let myDiary = self.myDiary else { return UITableViewCell() }
        
        diaryCell.setupItem(item: myDiary[indexPath.row])
        
        return diaryCell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diary = myDiary,
              let title = diary[indexPath.row].title,
              let fetchedDiary = CoreDataManager.shared.read(key: title) else { return }
        
        let diaryDetailViewController = DiaryDetailViewController(fetchedDiary: fetchedDiary, mode: .edit)
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}
