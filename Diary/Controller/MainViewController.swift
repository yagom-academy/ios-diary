//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didTappedRightAddButton()
}

final class MainViewController: UIViewController {
    enum Section {
        case main
    }
    
    weak var delegate: MainViewControllerDelegate?
    private let diaryContents: [DiaryContent]
    private let dateFormatter: DateFormatter
    private var diffableDatasource: UITableViewDiffableDataSource<Section, DiaryContent>?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.allowsSelection = false
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(diaryContents: [DiaryContent], dateFormatter: DateFormatter) {
        self.diaryContents = diaryContents
        self.dateFormatter = dateFormatter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstraints()
        setUpViewController()
        setUpTableViewDiffableDataSource()
        setUpTableViewDiffableDataSourceSnapShot()
    }

    private func configureUI() {
        view.addSubview(tableView)
    }
        
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(didTappedRightAddButton))
    }
}

// MARK: - TableViewDiffableDataSource
extension MainViewController {
    private func setUpTableViewDiffableDataSource() {
        diffableDatasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, diarySample in
            guard let self = self,
                    let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            
            let date = Date(timeIntervalSince1970: diarySample.date)
            let formattedDate = self.dateFormatter.string(from: date)
            cell.setUpContents(title: diarySample.title, date: formattedDate, body: diarySample.body)
            return cell
        })
    }
    
    private func setUpTableViewDiffableDataSourceSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, DiaryContent>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(diaryContents)
        diffableDatasource?.apply(snapShot)
    }
}

// MARK: - Button Action
extension MainViewController {
    @objc
    private func didTappedRightAddButton() {
        delegate?.didTappedRightAddButton()
    }
}
