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
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        title = diaryTitle
        setupViews()
    }
    
    private func setupViews() {
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(diaryTableView)
        
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            diaryTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            diaryTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            diaryTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8)
        ])
    }
}
