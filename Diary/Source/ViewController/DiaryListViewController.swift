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
    private let diaryManager = DiaryManager.shared
    
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
        fetchDiaries()
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
    
    private func pushDiaryViewController(with indexPath: IndexPath) {
        guard let diary = diaryDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        let diaryViewController = DiaryViewController(diary: diary)
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func showShareActivityView(for diary: Diary) {
        let activityViewController = UIActivityViewController(activityItems: [diary.content],
                                                              applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }
    
    private func delete(_ diary: Diary) {
        do {
            try diaryManager.remove(diary)
            deleteDiaryItem(of: diary)
        } catch {
            print("실패")
        }
    }
    
    private func deleteDiaryItem(of diary: Diary) {
        var currentSnapshot = diaryDataSource.snapshot()
        
        currentSnapshot.deleteItems([diary])
        diaryDataSource.apply(currentSnapshot)
    }
    
    private func apply(_ diaries: [Diary]) {
        var snapshot = NSDiffableDataSourceSnapshot<DiarySection, Diary>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries)
        diaryDataSource.apply(snapshot)
    }
    
    @objc
    private func tappedAddButton(_ sender: UIBarButtonItem) {
        do {
            try diaryManager.add(nil)
            fetchDiaries()
            pushDiaryViewController(with: Constant.firstDiary)
        } catch {
            print("실패")
        }
    }
    
    @objc
    private func fetchDiaries() {
        do {
            let diaries = try diaryManager.fetchObjects()
            apply(diaries)
        } catch {
            print("실패")
        }
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        pushDiaryViewController(with: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: nil) { [weak self] (_, _, success) in
            if let diary = self?.diaryDataSource.itemIdentifier(for: indexPath) {
                self?.delete(diary)
                success(true)
            } else {
                success(false)
            }
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        let shareAction = UIContextualAction(style: .normal,
                                             title: nil) { [weak self] (_, _, success) in
            if let diary = self?.diaryDataSource.itemIdentifier(for: indexPath) {
                self?.showShareActivityView(for: diary)
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
