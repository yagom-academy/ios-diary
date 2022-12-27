//  Diary - DiaryListViewController.swift
//  Created by Ayaan, zhilly on 2022/12/20

import UIKit

final class DiaryListViewController: UIViewController {
    private enum DiarySection: Hashable {
        case main
    }
    private enum Constant {
        static let title = "일기장"
        static let sampleDataName = "sample"
    }
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadDiary()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        title = Constant.title
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
    
    private func pushDiaryViewController(with diary: Diary = Diary(content: "", createdAt: Date())) {
        let diaryViewController = DiaryViewController(diary: diary)
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func loadDiary() {
        let manager = DiaryDataManager()
        let sampleDiary: [Diary] = manager.fetchDiaries()

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
        pushDiaryViewController(with: diary)
    }
}
