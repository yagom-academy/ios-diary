//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func didTappedRightAddButton(newDiaryContent: DiaryContentsDTO)
    func didSelectRowAt(diaryContent: DiaryContentsDTO)
}

final class MainViewController: UIViewController, AlertControllerShowable, ActivityViewControllerShowable {
    enum Section {
        case main
    }
    
    weak var delegate: MainViewControllerDelegate?
    private var diaryContents: [DiaryContentsDTO]?
    private let dateFormatter: DateFormatter
    private let useCase: MainViewControllerUseCaseType
    private var diffableDatasource: UITableViewDiffableDataSource<Section, DiaryContentsDTO>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.indentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(dateFormatter: DateFormatter, useCase: MainViewControllerUseCaseType) {
        self.dateFormatter = dateFormatter
        self.useCase = useCase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpConstraints()
        setUpViewController()
        setUpTableViewDiffableDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setUpDiaryContents()
        setUpTableViewDiffableDataSourceSnapShot(animated: false)
    }
    
    private func setUpDiaryContents() {
        diaryContents = useCase.fetchDiaryContentsDTO()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
    }
        
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(didTappedRightAddButton))
    }
}

// MARK: - TableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diaryContents else { return }
        
        delegate?.didSelectRowAt(diaryContent: diaryContents[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction: UIContextualAction = .init(style: .normal, title: "Share") { _, _, _ in
            self.didTappedShareAction(index: indexPath.row)
        }
        
        let deleteAction: UIContextualAction = .init(style: .destructive, title: "Delete") { _, _, _ in
            self.didTappedDeleteAction(index: indexPath.row)
        }
        
        let swipeActionConfiguration: UISwipeActionsConfiguration = .init(actions: [deleteAction, shareAction])
        
        swipeActionConfiguration.performsFirstActionWithFullSwipe = true
        return swipeActionConfiguration
    }
}

// MARK: - TableViewDiffableDataSource
extension MainViewController {
    private func setUpTableViewDiffableDataSource() {
        diffableDatasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, diaryContent in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.indentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            
            let date = Date(timeIntervalSince1970: diaryContent.date)
            let formattedDate = self.dateFormatter.string(from: date)
            
            cell.setUpContents(title: diaryContent.title, date: formattedDate, body: diaryContent.body)
            return cell
        })
    }
    
    private func setUpTableViewDiffableDataSourceSnapShot(animated: Bool = true) {
        guard let diaryContents else { return }
        var snapShot = NSDiffableDataSourceSnapshot<Section, DiaryContentsDTO>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(diaryContents)
        diffableDatasource?.apply(snapShot, animatingDifferences: animated)
    }
}

// MARK: - Button Action
extension MainViewController {
    @objc
    private func didTappedRightAddButton() {
        let newDiaryContent = useCase.createNewDiary()
        
        delegate?.didTappedRightAddButton(newDiaryContent: newDiaryContent)
    }
    
    private func didTappedDeleteAction(index: Int) {
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
//            self.diaryContents.remove(at: index)
//            self.setUpTableViewDiffableDataSourceSnapShot()
        }
        
        showAlertController(title: "진짜요?",
                            message: "정말로 삭제하시겠어요?",
                            style: .alert,
                            actions: [cancelAction, deleteAction])
    }
    
    private func didTappedShareAction(index: Int) {
        guard let diaryContents else { return }
        
        let entity = diaryContents[index]
        let sharedItem = entity.title + "\n" + entity.body
        
        self.showActivityViewController(items: [sharedItem as Any])
    }
}
