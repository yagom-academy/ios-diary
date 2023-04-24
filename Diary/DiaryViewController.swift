//
//  Diary - DiaryViewController.swift
//  Created by 리지, Goat
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class DiaryViewController: UIViewController {
    
    private let diaryTableView: UITableView = UITableView()
    private var sampleDiary: [SampleDiary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decodeDiary()
        configurUI()
        setupView()
    }
    
    private func decodeDiary() {
        let diaryFileName = "sample"
        sampleDiary = Decoder.parseJSON(fileName: diaryFileName, returnType: [SampleDiary].self) ?? []
    }
    
    private func configurUI() {
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
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
    }
}

extension DiaryViewController: UITableViewDelegate {
}

extension DiaryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleDiary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let diaryCell: DiaryTableViewCell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier) as? DiaryTableViewCell else { return UITableViewCell() }
        
        let title = sampleDiary[indexPath.row].title
        let date = sampleDiary[indexPath.row].createdDate
        let body = sampleDiary[indexPath.row].body
        
        diaryCell.setUpLabel(title: title, date: date, body: body)
                
        return diaryCell
    }
    
    
}


