//
//  Diary - DiaryListViewController.swift
//  Created by Finnn, 수꿍 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

enum Section {
    case main
}

final class DiaryListViewController: UIViewController {
    
    // MARK: - Properties

    private let diaryView = DiaryListView()
    private var dataSource: UITableViewDiffableDataSource<Section, Diary>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
    private var fetchResultsController: NSFetchedResultsController<Diary> = {
        let request = NSFetchRequest<Diary>(entityName: "Diary")
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 10
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let fetchResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchResultsController
    }()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = diaryView
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItems()
        registerTableView()
        configureDataSource()
        configureDelgate()
    }
    
    // MARK: - Methods
    
        
    }
    
    private func configureNavigationItems() {
        title = NavigationItem.diaryTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: SystemImage.plus),
            style: .plain,
            target: self,
            action: #selector(plusButtonTapped)
        )
    }
    
    @objc private func plusButtonTapped() {
        moveToDiaryContentsViewController()
    }
    
    private func moveToDiaryContentsViewController() {
        navigationController?.pushViewController(
            DiaryContentsViewController(),
            animated: true
        )
    }
    
    private func registerTableView() {
        let tableView = diaryView.tableView
        
        tableView.register(
            DiaryListCell.self,
            forCellReuseIdentifier: DiaryListCell.identifier
        )
        tableView.dataSource = dataSource
    }
    
    private func configureDataSource() {
        configureSnapshot()
        
        let tableView = diaryView.tableView
        
        dataSource = UITableViewDiffableDataSource<Section, Diary>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DiaryListCell.identifier,
                    for: indexPath
                ) as? DiaryListCell else {
                    return nil
                }
                
                cell.titleLabel.text = item.title
                cell.dateLabel.text = item.createdAt?.localizedString
                cell.contentLabel.text = item.body
                cell.accessoryType = .disclosureIndicator
                
                return cell
            }
        )
        
        dataSource?.apply(snapshot)
    }
    
    private func configureSnapshot() {
        do {
            try fetchResultsController.performFetch()
            
            guard let diaries = fetchResultsController.sections?.first?.objects as? [Diary] else {
                return
            }
            
            snapshot.appendSections([.main])
            snapshot.appendItems(diaries)
        } catch {
            presentErrorAlert(error)
        }
        
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries)
    }
    
    private func configureDelgate() {
        diaryView.tableView.delegate = self
        fetchResultsController.delegate = self
    }
}

// MARK: - UITableViewDelegate

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let diary = dataSource?.itemIdentifier(for: indexPath)
        let nextViewController = DiaryContentsViewController()

        nextViewController.diary = diary
        nextViewController.isEditingMemo = true
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension DiaryListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let diary = anObject as? Diary else {
            return
        }
        
        switch type {
        case .insert:
            guard snapshot.numberOfItems != .zero,
                  let newIndexPath = newIndexPath,
                  let lastDiary = dataSource?.itemIdentifier(for: newIndexPath) else {
                snapshot.appendItems([diary])
                return
            }
            
            snapshot.insertItems([diary], beforeItem: lastDiary)
        case .delete:
            snapshot.deleteItems([diary])
            break
        case .update:
            snapshot.reloadSections([.main])
            break
        default:
            break
        }
    }
}
