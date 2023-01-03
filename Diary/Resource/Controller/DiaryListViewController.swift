//
//  DiaryListViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

final class DiaryListViewController: UIViewController {
    private let diaryListTableView = UITableView()
    private var diaryModels: [DiaryModel] = [] {
        didSet {
            diaryListTableView.reloadData()
        }
    }
    
    override func loadView() {
        view = diaryListTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDiaryListTableView()
        addObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCoreData()
    }
    
    private func fetchCoreData() {
        diaryModels = CoreDataManager.shared.fetchAllModels()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance =
        navigationController?.navigationBar.standardAppearance
        title = Namespace.diary
        
        let rightBarButtonImage = UIImage(systemName: Namespace.plusImage)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tappedPlusButton))
    }
    
    @objc private func tappedPlusButton(_ sender: UIBarButtonItem) {
        let diaryItemViewController = DiaryItemViewController()
        navigationController?.pushViewController(diaryItemViewController, animated: true)
    }
    
    private func configureDiaryListTableView() {
        diaryListTableView.dataSource = self
        diaryListTableView.delegate = self
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showAlert(_:)),
                                               name: Notification.Name("CoreDataError"),
                                               object: nil)
    }
    
    @objc private func showAlert(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let title = userInfo[Namespace.alertTitle, default: Namespace.empty] as? String else { return }
        
        showErrorAlert(title: title)
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        diaryListTableView.register(DiaryListTableViewCell.self,
                                    forCellReuseIdentifier: DiaryListTableViewCell.identifier)
        
        guard let cell = diaryListTableView.dequeueReusableCell(
            withIdentifier: DiaryListTableViewCell.identifier,
            for: indexPath
        ) as? DiaryListTableViewCell else { return UITableViewCell() }
        
        cell.updateContent(data: diaryModels[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryItemViewController = DiaryItemViewController(diaryItem: diaryModels[indexPath.row])
        diaryItemViewController.fillTextView(with: diaryModels[indexPath.row])
        navigationController?.pushViewController(diaryItemViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []
        
        let shareAction = UIContextualAction(style: .normal, title: Namespace.share) { _, _, _  in
            let diaryForm = DiaryItemManager.shared.createDiaryShareForm(diaryItem: self.diaryModels[indexPath.row])
            let activityVC = UIActivityViewController(activityItems: [diaryForm], applicationActivities: nil)
            self.present(activityVC, animated: true)
        }
        shareAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: Namespace.delete) { _, _, _  in
            let handler: (UIAlertAction) -> Void = { _ in
                DiaryItemManager.shared.deleteDiary(data: self.diaryModels[indexPath.row])
                self.diaryModels = CoreDataManager.shared.fetchAllModels()
            }
            self.showDeleteAlert(handler: handler)
        }
        
        actions.append(deleteAction)
        actions.append(shareAction)
        
        return UISwipeActionsConfiguration(actions: actions)
    }
}
