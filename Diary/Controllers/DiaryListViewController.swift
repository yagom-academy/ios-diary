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
    
    // MARK: Properties
    
    private let diaryView = DiaryListView()
    private var dataSource: UITableViewDiffableDataSource<Section, Diary>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
    private var fetchResultsController: NSFetchedResultsController<Diary>?
    private var isFiltering: Bool {
        guard let searchController = navigationItem.searchController else {
            return false
        }
        
        let isActive = searchController.isActive
        let isSearchBarHasText = searchController.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
    }
    private var iconImages: [UIImage] = []
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = diaryView
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItems()
        registerTableView()
        configureFetchResultsController(from: fetchAllDiaryRequest())
        configureSnapshot()
        configureDataSource()
        configureDelgate()
        configureSearchController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.sizeToFit()
        dataSource?.apply(snapshot)
    }
    
    // MARK: - Methods
    
    private func configureNavigationItems() {
        title = NavigationItem.diaryTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: SystemImage.plus,
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
    
    private func configureFetchResultsController(from request: NSFetchRequest<Diary>) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        
        fetchResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    private func fetchAllDiaryRequest() -> NSFetchRequest<Diary> {
        let fetchRequest = NSFetchRequest<Diary>(entityName: DiaryCoreData.entityName)
        let sort = NSSortDescriptor(key: DiaryCoreData.Key.createdAt, ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 10
        
        return fetchRequest
    }
    
    private func fetchDiaryRequest(from text: String) -> NSFetchRequest<Diary> {
        let fetchRequest: NSFetchRequest<Diary> = NSFetchRequest(entityName: DiaryCoreData.entityName)
        let titlePredicate = NSPredicate(format: DiaryCoreData.Predicate.contatingTitle, text)
        let bodyPredicate = NSPredicate(format: DiaryCoreData.Predicate.containingBody, text)
        let titleOrBodyPredicate = NSCompoundPredicate(
            type: NSCompoundPredicate.LogicalType.or,
            subpredicates: [titlePredicate, bodyPredicate]
        )
        
        fetchRequest.predicate = titleOrBodyPredicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(
            key: DiaryCoreData.Key.createdAt,
            ascending: true
        )]
        
        return fetchRequest
    }
    
    private func configureDataSource() {
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
                cell.dateLabel.text = item.createdAt.localizedString
                cell.bodyLabel.text = item.body
                if self.iconImages.count > indexPath.row {
                    cell.weatherIconImageView.image = self.iconImages[indexPath.row]
                }
                
                cell.accessoryType = .disclosureIndicator
                
                return cell
            }
        )
        
        dataSource?.apply(snapshot)
    }
    
    private func configureSnapshot() {
        do {
            try fetchResultsController?.performFetch()
            
            guard let diaries = fetchResultsController?.fetchedObjects else {
                return
            }
            
            diaries.forEach {
                guard let weatherImageAPIManager = WeatherImageAPIManager(icon: $0.icon) else {
                    return
                }
                
                weatherImageAPIManager.requestImage(id: $0.id) { result in
                    switch result {
                    case .success(let image):
                        self.iconImages.append(image)
                    case .failure(let error):
                        self.presentErrorAlert(error)
                    }
                }
            }
            
            snapshot.appendSections([.main])
            snapshot.appendItems(diaries)
        } catch {
            presentErrorAlert(error)
        }
    }
    
    private func configureDelgate() {
        diaryView.tableView.delegate = self
        fetchResultsController?.delegate = self
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = SearchControllerItem.placeHolder
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.backgroundColor = .white
        navigationItem.searchController = searchController
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let diary = self.dataSource?.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: ActionSheet.deleteActionTitle
        ) { [weak self] action, view, completion in
            self?.deleteDiary(using: diary.id)
        }
        
        let shareAction = UIContextualAction(
            style: .normal,
            title: ActionSheet.shareActionTitle
        ) { [weak self] action, view, completion in
            self?.shareDiary(diary.title, diary.body)
            completion(true)
        }
        
        deleteAction.image = SystemImage.trash
        shareAction.backgroundColor = .systemBlue
        shareAction.image = SystemImage.share
        
        let swipeActionCongifuration = UISwipeActionsConfiguration(actions: [
            deleteAction,
            shareAction
        ])
        swipeActionCongifuration.performsFirstActionWithFullSwipe = false
        return swipeActionCongifuration
    }
    
    private func deleteDiary(using id: UUID) {
        do {
            try CoreDataManager.shared.delete(using: id)
            dataSource?.apply(snapshot)
        } catch {
            presentErrorAlert(error)
        }
    }
    
    private func shareDiary(_ title: String, _ body: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [title + String(NewLine.lineFeed) + body],
            applicationActivities: nil
        )
        self.present(activityViewController, animated: true)
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
            WeatherImageAPIManager(icon: diary.icon)?.requestImage(id: diary.id) { result in
                switch result {
                case .success(let image):
                    self.iconImages.append(image)
                    DispatchQueue.main.async {
                        self.diaryView.tableView.reloadData()
                    }
                case .failure(let error):
                    self.presentErrorAlert(error)
                }
            }
            
            guard self.snapshot.numberOfItems != .zero,
                  let newIndexPath = newIndexPath,
                  let lastDiary = self.dataSource?.itemIdentifier(for: newIndexPath) else {
                self.snapshot.appendItems([diary])
                return
            }
            
            self.snapshot.insertItems([diary], beforeItem: lastDiary)
        case .delete:
            snapshot.deleteItems([diary])
        case .update:
            snapshot.reloadSections([.main])
        default:
            break
        }
    }
}

// MARK: - UISearchResultsUpdating

extension DiaryListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        snapshot.deleteAllItems()
        
        guard isFiltering,
            let searchBarText = searchController.searchBar.text else {
            configureFetchResultsController(from: fetchAllDiaryRequest())
            configureSnapshot()
            dataSource?.apply(snapshot)
            return
        }
        
        let fetchRequest = fetchDiaryRequest(from: searchBarText)
        configureFetchResultsController(from: fetchRequest)
        fetchResultsController?.delegate = self
        configureSnapshot()
        dataSource?.apply(snapshot)
    }
}
