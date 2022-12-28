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
        static let firstDiary: IndexPath = .init(row: 0, section: 0)
    }
    private let diaryDataManager = DiaryDataManager()
    
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
        setupNotification()
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
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadDiary),
                                               name: .didChangeDiaryCoreData,
                                               object: nil)
    }
    
    private func pushDiaryViewController(with diary: Diary) {
        let diaryViewController = DiaryViewController(diary: diary)
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func showShareView(_ diary: Diary) {
        let activityViewController = UIActivityViewController(activityItems: [diary.content],
                                                              applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }
    
    private func delete(_ diary: Diary) {
        diaryDataManager.remove(diary)
    }
    
    @objc
    private func tappedAddButton(_ sender: UIBarButtonItem) {
        diaryDataManager.addNewDiary()
        
        guard let diary = diaryDataSource.itemIdentifier(for: Constant.firstDiary) else {
            return
        }
        
        pushDiaryViewController(with: diary)
    }
    
    @objc
    private func loadDiary() {
        guard navigationController?.topViewController == self else { return }
        let sampleDiary: [Diary] = diaryDataManager.fetchDiaries()
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
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: nil) { (_, _, success) in
            if let diary = self.diaryDataSource.itemIdentifier(for: indexPath) {
                self.delete(diary)
                success(true)
            } else {
                success(false)
            }
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let shareAction = UIContextualAction(style: .normal,
                                             title: nil) { (_, _, success) in
            if let diary = self.diaryDataSource.itemIdentifier(for: indexPath) {
                self.showShareView(diary)
                success(true)
            } else {
                success(false)
            }
        }
        shareAction.backgroundColor = UIColor(named: "CustomBlue")
        shareAction.image = UIImage(systemName: "square.and.arrow.up.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}
