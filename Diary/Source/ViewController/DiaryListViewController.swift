//  Diary - DiaryListViewController.swift
//  Created by Ayaan, zhilly on 2022/12/20

import UIKit

fileprivate enum DiarySection: Hashable {
    case main
}

final class DiaryListViewController: UIViewController {
    private let diaryTitle: String = "일기장"
    private let diaryTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var diaryDataSource: UITableViewDiffableDataSource = {
        let dataSource = UITableViewDiffableDataSource<DiarySection, Diary>(
            tableView: diaryTableView
        ) { (tableView, indexPath, diary) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryCell.reuseIdentifier,
                for: indexPath
            ) as? DiaryCell else { return nil }
            
            cell.configure(with: diary)
            
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
        diaryTableView.delegate = self
        
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
                                             action: #selector(tappedAddButton))
        
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    @objc
    private func tappedAddButton(_ sender: UIBarButtonItem) {
        pushDiaryViewController()
    }
    
    private func pushDiaryViewController(_ diary: Diary = Diary()) {
        let diaryViewController = DiaryViewController(diary: diary)
        navigationController?.pushViewController(diaryViewController, animated: true)
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

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let diary = diaryDataSource.itemIdentifier(for: indexPath) else { return }
        pushDiaryViewController(diary)
    }
}
