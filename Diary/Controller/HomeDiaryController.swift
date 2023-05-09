//
//  Diary - HomeDiaryController.swift
//  Created by Andrew, Brody.
// 

import UIKit
import CoreData

final class HomeDiaryController: UIViewController {
    
    private let diaryTableView = UITableView()
    private let localizedDateFormatter = DateFormatter(
        languageIdentifier: Locale.preferredLanguages.first ?? Locale.current.identifier
    )
    
    private let diaryService = DiaryService(coreDataStack: CoreDataManager.shared)
    
    private lazy var fetchedDiaryResultsController: NSFetchedResultsController<Diary> = {
        let fetchRequest = NSFetchRequest<Diary>(entityName: "Diary")
        let createdDateSort = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [createdDateSort]
        
        let fetchResult = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager.shared.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchResult.delegate = self
        
        return fetchResult
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureUI()
        setupFetchedResultsController()
        fetchDiaryData()
    }
    
    private func setupTableView() {
        diaryTableView.dataSource = self
        diaryTableView.delegate = self
        diaryTableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.identifier)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        
        view.addSubview(diaryTableView)
        diaryTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            diaryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "일기장".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddDiaryButton)
        )
    }
    
    private func setupFetchedResultsController() {
        fetchedDiaryResultsController.delegate = self
        
    }
    
    private func fetchDiaryData() {
        do {
            try fetchedDiaryResultsController.performFetch()
        } catch {
            
        }
    }
    
    @objc private func didTapAddDiaryButton() {
        navigationController?.pushViewController(ProcessViewController(diaryService: diaryService), animated: true)
    }
}

extension HomeDiaryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedDiaryResultsController.sections?[safe: section]?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DiaryCell.identifier,
            for: indexPath
        ) as? DiaryCell else {
            return UITableViewCell()
        }
        
        let diary = fetchedDiaryResultsController.object(at: indexPath)
        cell.configureData(data: diary, localizedDateFormatter: localizedDateFormatter)
        
        return cell
    }
}

extension HomeDiaryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = fetchedDiaryResultsController.object(at: indexPath)
        let addDiaryViewController = ProcessViewController(diary: diary, diaryService: diaryService)
        navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제".localized()) { [weak self]  _, _, _ in
            guard let diary = self?.fetchedDiaryResultsController.object(at: indexPath) else {
                return
            }
            self?.diaryService.delete(id: diary.id)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "공유".localized()) { [weak self] _, _, _ in
            let diary = self?.fetchedDiaryResultsController.object(at: indexPath)
            let activityVC = UIActivityViewController(
                activityItems: [diary?.title, diary?.body],
                applicationActivities: nil
            )
            
            self?.present(activityVC, animated: true, completion: nil)
        }
        
        deleteAction.backgroundColor = .systemRed
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

extension HomeDiaryController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                diaryTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                diaryTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                diaryTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                diaryTableView.moveRow(at: indexPath, to: newIndexPath)
                diaryTableView.reloadRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
