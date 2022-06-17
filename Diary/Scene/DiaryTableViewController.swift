//
//  Diary - DiaryTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryTableViewController: UITableViewController {
    private var dataSource: DiaryTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        setUpNavigationBar()
        setUpTableView()
    }
    
    private func setUpNavigationBar() {
        title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtondidTap)
        )
    }
    
    @objc
    private func addButtondidTap() {
        dataSource?.create()
        guard let diary = dataSource?.diarys.first else { return }
        
        let diaryViewController = DiaryDetailViewController(diary: diary)
        diaryViewController.delegate = self
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func setUpTableView() {
        tableView.separatorInset.left = 20
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        makeDataSource()
        dataSource?.read()
    }
    
    private func makeDataSource() {
        dataSource = DiaryTableViewDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryCell.reuseIdentifier,
                for: indexPath
            ) as? DiaryCell
            
            cell?.setUpItem(with: item)
            return cell
        }
    }
}

// MARK: TableViewDelegate

extension DiaryTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diary = dataSource?.diarys[indexPath.row] else { return }
        
        let diaryViewController = DiaryDetailViewController(diary: diary)
        diaryViewController.delegate = self
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        return ContextualActionBuilder()
            .addContextualAction(
                title: "삭제",
                image: UIImage(systemName: "trash.circle"),
                style: .destructive,
                action: { [weak self] in
                    guard let diary = self?.dataSource?.diarys[indexPath.row] else { return }
                    self?.dataSource?.delete(diary: diary)
                })
            .addContextualAction(
                title: "공유",
                backgroundColor: .systemBlue,
                image: UIImage(systemName: "square.and.arrow.up.circle"),
                style: .normal,
                action: { [weak self] in
                    guard let diary = self?.dataSource?.diarys[indexPath.row] else { return }
                    
                    let text = diary.title + "\n\n" + diary.body
                    let activityViewController = UIActivityViewController(
                        activityItems: [text],
                        applicationActivities: nil
                    )
                    
                    self?.present(activityViewController, animated: true)
                })
            .make()
    }
}

// MARK: DiaryDetailViewDelegate

extension DiaryTableViewController: DiaryDetailViewDelegate {
    func update(diary: Diary) {
        dataSource?.update(diary: diary)
    }
    
    func delete(diary: Diary) {
        dataSource?.delete(diary: diary)
    }
}
