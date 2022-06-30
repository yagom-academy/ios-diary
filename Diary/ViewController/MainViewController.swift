//
//  Diary - MainViewController.swift
//  Created by 우롱차, RED on 2022/06/14.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private enum Constant {
        static let navigationTitle = "일기장"
    }
    
    private var mainView: UITableView
    private var viewModel: TableViewModel
    private weak var detailViewController: DetailViewController?
    private var datas: [DiaryInfo] = []
    
    init(view: UITableView, viewModel: TableViewModel) {
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
        viewModel.delegate = self
        setMainViewSetting()
        setNavigationSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requireAction(.loadData)
    }
    
    private func setMainViewSetting() {
        mainView.dataSource = self
        mainView.delegate = self
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.register(MainViewCell.self, forCellReuseIdentifier: MainViewCell.identifier)
    }
}

// MARK: Navigation Method
extension MainViewController {
    private func setNavigationSetting() {
        navigationItem.title = Constant.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(rightBarbuttonClicked(_:))
        )
    }
    
    @objc
    private func rightBarbuttonClicked(_ sender: Any) {
        viewModel.requireAction(.create)
    }
}

// MARK: tableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(view: DetailView(), viewModel: viewModel)
        let diary = datas[indexPath.row]
        detailViewController.updateData(diary: diary)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let like = UIContextualAction(style: .normal, title: "Delete") { (_, _, success: @escaping (Bool) -> Void) in
            let cancleButton = UIAlertAction(title: "취소", style: .cancel)
            let deleteButton = UIAlertAction(title: "삭제", style: .destructive) { _ in
                let diary = self.datas[indexPath.row]
                // 애니메이션 추후 변경 하기
                self.viewModel.requireAction(.delete(diary))
//                self.viewModel.requireAction(.loadData)
                self.datas.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
//                self.viewModel.requireAction(.delete(diary))
                
            }
            self.alertMaker.makeAlert(title: "진짜요?",
                                      message: "정말로 삭제하시겠어요?",
                                      buttons: [cancleButton, deleteButton])
            success(true)
        }
        
        like.backgroundColor = .systemPink
        let share = UIContextualAction(style: .normal, title: "Share") { (_, _, success: @escaping (Bool) -> Void) in
            // safe Array 처리를 하면 좋을 것 같음
            let diaryInfo = self.datas[indexPath.row]
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
        guard datas.count > indexPath.row else {
            return MainViewCell()
        }
        let diary = datas[indexPath.row]
        
        cell.setDiaryData(diary)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
}

extension MainViewController: TableViewModelDelegate {
    
    func reloadData(_ datas: [DiaryInfo]) {
        self.datas = datas
        mainView.reloadData()
    }
    
    func asyncUpdateHandler(_ data: DiaryInfo) {
        guard let detailViewController = detailViewController else { return }
            detailViewController.updateNavigationImage(with: data)
    }
    
    func createHandler(_ data: DiaryInfo) {
        let detailViewController = DetailViewController(view: DetailView(), viewModel: self.viewModel)
        self.detailViewController = detailViewController
        self.viewModel.requireAction(.asyncUpdate(data))
        
        detailViewController.updateData(diary: data)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func errorHandler(_ error: Error) {
        self.alertMaker.makeErrorAlert(error: error)
    }

}
