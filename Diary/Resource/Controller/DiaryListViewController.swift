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
    
    private var diaryItemManager = DiaryItemManager()
    lazy var activityViewController = UIActivityViewController(diaryItemManager: diaryItemManager)
    
    override func loadView() {
        view = diaryListTableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCoreData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDiaryListTableView()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance =
        navigationController?.navigationBar.standardAppearance
        title = Namespace.navigationTitle
        
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
    
    private func fetchCoreData() {
        diaryModels = CoreDataStack.shared.fetchAllDiaryModels()
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
        let diaryItemViewController = DiaryItemViewController()
        diaryItemViewController.receive(data: diaryModels[indexPath.row])
        navigationController?.pushViewController(diaryItemViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []

        let shareAction = UIContextualAction(style: .normal, title: "Share") { _, _, _  in
            self.present(self.activityViewController, animated: true)
        }
        shareAction.backgroundColor = .blue

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _  in
            CoreDataStack.shared.deleteDiary(with: self.diaryModels[indexPath.row].id)
            self.diaryModels = CoreDataStack.shared.fetchAllDiaryModels()
        }
        
        actions.append(deleteAction)
        actions.append(shareAction)
        
        return UISwipeActionsConfiguration(actions: actions)
    }
}

// MARK: Namespace
fileprivate enum Namespace {
    static let navigationTitle = "일기장"
    static let plusImage = "plus"
}
