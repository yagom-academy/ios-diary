//
//  DiaryListViewController.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/17.
//

import UIKit

final class DiaryListViewController: UIViewController {
    // MARK: - Design

    private enum Design {
        static let navigationTitle = "일기장"
        static let alertControllerTitle = "진짜요?"
        static let alertControllerMessage = "정말로 삭제하시겠어요?🐒"
        static let alertCancelAction = "취소"
        static let alertDeleteAction = "삭제"
        static let alertShareAction = "공유"
    }
    
    // MARK: - properties

    private var tableView = UITableView()
    private var diaryData: DiaryDataManagerProtocol?

    // MARK: - view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureNavigationBarItems()
        configureView()
        configureViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadView()
    }

    // MARK: - methods

    private func reloadView() {
        diaryData = DiaryDataManager().provider
        tableView.reloadData()
    }
    
    private func shareAlertActionDidTap(index: Int) {
        let title = diaryData?.diaryItems?[index].title
        let activityViewController = UIActivityViewController(activityItems: [title as Any],
                                                              applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }
    
    private func deleteAlertActionDidTap(index: Int) {
        let alertController = UIAlertController(title: Design.alertControllerTitle,
                                                message: Design.alertControllerMessage,
                                                preferredStyle: .alert)
        let cancelAlertAction = UIAlertAction(title: Design.alertCancelAction,
                                              style: .cancel)
        let deleteAlertAction = UIAlertAction(title: Design.alertDeleteAction,
                                              style: .destructive) { _ in self.deleteDiaryData(index: index)}
        
        alertController.addAction(cancelAlertAction)
        alertController.addAction(deleteAlertAction)
        
        present(alertController, animated: true)
    }
    
    private func deleteDiaryData(index: Int) {
        guard let createdAt = diaryData?.diaryItems?[index].createdAt else { return }
        
        CoreDataManager.shared.delete(createdAt: createdAt)
        reloadView()
    }
    
    private func configureNavigationBarItems() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(tappedPlusButton))

        navigationItem.rightBarButtonItem = plusButton
        navigationItem.title = Design.navigationTitle
    }
    
    @objc private func tappedPlusButton() {
        navigationController?.pushViewController(DiaryRegisterViewController(), animated: true)
    }
    
    // MARK: - Layout Methods

    private func configureView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryTableViewCell.self,
                            forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
    }

    private func configureViewLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
}

// MARK: - extensions

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        diaryData?.diaryItems?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.reuseIdentifier)
                as? DiaryTableViewCell else { return UITableViewCell() }

        cell.titleLabel.text = diaryData?.diaryItems?[indexPath.row].title
        cell.dateLabel.text = diaryData?.diaryItems?[indexPath.row].createdAt.convertDate()
        cell.bodyLabel.text = diaryData?.diaryItems?[indexPath.row].body
        
        WeatherDataManager().weatheIconRequest(id: diaryData?.diaryItems?[indexPath.row].icon ?? "") { image in
            DispatchQueue.main.async {
                guard indexPath == tableView.indexPath(for: cell) else { return }
                cell.weatherIconImageView.image = image
            }
        }
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryDetailViewController = DiaryDetailViewController()
        diaryDetailViewController.diaryDetailData = diaryData?.diaryItems?[indexPath.row]
        
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: Design.alertDeleteAction, handler: { _, _, completionHaldler in
            self.deleteAlertActionDidTap(index: indexPath.row)
            completionHaldler(true)
        })
        let shareSwipeAction = UIContextualAction(style: .normal, title: Design.alertShareAction, handler: { _, _, completionHaldler in
            self.shareAlertActionDidTap(index: indexPath.row)
            completionHaldler(true)
        })
        
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction, shareSwipeAction])
    }
}
