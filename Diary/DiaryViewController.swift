//  Diary - DiaryViewController.swift
//  Created by Ayaan, zhilly on 2022/12/20

import UIKit

private enum DiarySection: Hashable {
    case main
}

final class DiaryViewController: UIViewController {
    private let diaryTitle: String = "일기장"
    private lazy var diaryTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var diaryDataSource: UITableViewDiffableDataSource = {
        let dataSource = UITableViewDiffableDataSource<DiarySection, Diary>(
            tableView: diaryTableView
        ) { (tableView, indexPath, diary) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryCell.identifier,
                for: indexPath
            ) as? DiaryCell else { return nil }
            
            cell.setupDiary(diary)
            return cell
        }
        
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        applySampleData()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        title = diaryTitle
        setupViews()
        setupBarButtonItem()
    }
    
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(diaryTableView)
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setupBarButtonItem() {
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                             style: .plain,
                                             target: self,
                                             action: nil)
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func applySampleData() {
        guard let sampleData = NSDataAsset(name: "sample"),
              let sampleDiary: [Diary] = try? JSONDecoder().decode([Diary].self,
                                                                   from: sampleData.data) else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<DiarySection, Diary>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sampleDiary)
        diaryDataSource.apply(snapshot)
    }
}
