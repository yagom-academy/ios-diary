//
//  Diary - MainViewController.swift
//  Created by 우롱차, RED on 2022/06/14.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    private enum Constnat {
        static let navigationTitle = "일기장"
    }
    
    private var mainView: UITableView
    private var viewModel: TableViewModel<DiaryUseCase>
    
    init(view: UITableView, viewModel: TableViewModel<DiaryUseCase>) {
        self.mainView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setMainViewSetting()
        setNavigationSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setMainViewSetting() {
        do {
            try viewModel.loadData()
            mainView.dataSource = self
            mainView.delegate = self
            mainView.translatesAutoresizingMaskIntoConstraints = false
            mainView.register(MainViewCell.self, forCellReuseIdentifier: MainViewCell.identifier)
        } catch {
            alertMaker.makeErrorAlert(error: error)
        }
    }
}

// MARK: Navigation Method
extension MainViewController {
    private func setNavigationSetting() {
        navigationItem.title = Constnat.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(rightBarbuttonClicked(_:))
        )
    }
    
    @objc
    private func rightBarbuttonClicked(_ sender: Any) {
        do {
            let detailViewController = DetailViewController()
            detailViewController.delegate = self
            let data = try viewModel.create(data: DiaryInfo(title: "", body: "", date: Date(), key: nil))
            detailViewController.updateData(diary: data)
            navigationController?.pushViewController(detailViewController, animated: true)
        } catch {
            alertMaker.makeErrorAlert(error: error)
        }
    }
}

// MARK: tableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.updateData(diary: viewModel.data[indexPath.row])
        detailViewController.delegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let like = UIContextualAction(style: .normal, title: "Delete") { (_, _, success: @escaping (Bool) -> Void) in
            let cancleButton: UIAlertAction = UIAlertAction(title: "취소", style: .cancel)
            let deleteButton: UIAlertAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                do {
                    try self.viewModel.delete(data: self.viewModel.data[indexPath.row])
                    try self.viewModel.loadData()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } catch {
                    self.alertMaker.makeErrorAlert(error: error)
                }
            }
            self.alertMaker.makeAlert(title: "진짜요?", message: "정말로 삭제하시겠어요?", buttons: [cancleButton, deleteButton])
            success(true)
        }
        like.backgroundColor = .systemPink
        
        let share = UIContextualAction(style: .normal, title: "Share") { (_, _, success: @escaping (Bool) -> Void) in
            let diaryInfo = self.viewModel.data[indexPath.row]
            let activityController = UIActivityViewController(
                activityItems: [diaryInfo.body ?? ""],
                applicationActivities: nil)
            self.present(activityController, animated: true)
            success(true)
        }
        share.backgroundColor = .systemTeal
        
        return UISwipeActionsConfiguration(actions: [like, share])
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainViewCell.identifier, for: indexPath
        ) as? MainViewCell else {
            return MainViewCell()
        }
        cell.setDiaryData(viewModel.data[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
}

extension MainViewController: UpdateDelegateable {
    func updatae(diaryInfo: DiaryInfo) {
        do {
            try viewModel.update(data: diaryInfo)
            try viewModel.loadData()
            mainView.reloadData()
        } catch {
            alertMaker.makeErrorAlert(error: error)
        }
    }
    
    func delete(diarInfo: DiaryInfo) {
        do {
            try viewModel.delete(data: diarInfo)
            try viewModel.loadData()
            mainView.reloadData()
        } catch {
            alertMaker.makeErrorAlert(error: error)
        }
    }
}
