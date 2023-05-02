//
//  Diary - DiaryListViewController.swift
//  Created by Rowan, Harry. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    private let tableView = UITableView()
    private var diaryList: [DiaryContents] = []
    private let sampleDecoder = DiaryDecodeManager()
    private let alertFactory: AlertFactoryService = AlertImplementation()
    private let alertDataMaker: AlertDataService = AlertViewDataMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRootView()
        setUpNavigationBar()
        setUpTableView()
//        parseDiarySample()
//        fetchDiaryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDiaryList()
        tableView.reloadData()
    }

    private func setUpRootView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    private func setUpNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDiary))
        
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    private func addDiary() {
        let nextViewController = DiaryContentViewController()
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryListCell.self,
                           forCellReuseIdentifier: DiaryListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        setUpTableViewLayout()
    }
    
    private func setUpTableViewLayout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safe.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
//    private func parseDiarySample() {
//        guard let data = NSDataAsset(name: "sample")?.data else { return }
//
//        let result = sampleDecoder.decode(type: [DiaryContents].self, data: data)
//
//        switch result {
//        case .success(let sample):
//            diaryList = sample
//        case .failure(let error):
//            let alertViewData = alertDataMaker.decodeError(error)
//            let alert = alertFactory.makeAlert(for: alertViewData)
//
//            present(alert, animated: true)
//        }
//    }
    
    private func fetchDiaryList() {
        let result = DiaryCoreDataManager.shared.fetchDiary()
        
        switch result {
        case .success(let diaryList):
            self.diaryList = diaryList.map { diary in
                DiaryContents(title: diary.title, body: diary.body, createdDate: diary.date, id: diary.id)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
        
        print(diaryList)
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: DiaryListCell.identifier,
                                 for: indexPath) as? DiaryListCell
        else { return UITableViewCell() }
        
        let diary = diaryList[indexPath.row]
        let date = Date(timeIntervalSince1970: diary.createdDate)
        let formattedDate = DateFormatter.diaryForm.string(from: date)
        
        cell.configureLabels(title: diary.title, date: formattedDate, body: diary.body)
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = DiaryContentViewController(diary: diaryList[indexPath.row])
        
        navigationController?.pushViewController(nextViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
