//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreData

final class MainViewController: UIViewController {
    // MARK: - Properties
    
    private let mainDiaryView = MainDiaryView()
    private var diaries: [Diary] = []
    private let alertControllerManager = AlertControllerManager()
    private let activityControllerManager = ActivityControllerManager()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainDiaryView
        configureNavigationItem()
        setUpTableView()
        decodeDiaryData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let entity = readCoreData() {
            diaries = convertToDiary(from: entity)
            mainDiaryView.diaryTableView.reloadData()
        }
    }
    
    // MARK: - Private Methods
    
    private func configureNavigationItem() {
        navigationItem.title = NameSpace.navigationTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addDiary)
        )
    }
    
    private func setUpTableView() {
        mainDiaryView.diaryTableView.dataSource = self
        mainDiaryView.diaryTableView.delegate = self
    }
    
    private func decodeDiaryData() {
        guard let dataAsset = NSDataAsset(name: NameSpace.assetName) else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            diaries = try decoder.decode([Diary].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func convertToDiary(from entityArray: [Entity]) -> [Diary] {
        var diaryArray: [Diary] = []
        
        entityArray.forEach { entity in
            guard let title = entity.title,
                  let body = entity.body,
                  let createdDate = entity.createdDate,
                  let createdAt = Int(createdDate),
                  let totalText = entity.totalText,
                  let id = entity.id else { return }
            
            let diary = Diary(title: title,
                              body: body,
                              createdAt: createdAt,
                              totalText: totalText,
                              id: id)
            
            diaryArray.append(diary)
        }
        
        return diaryArray
    }
    
    private func showDeleteAlert() {
        present(alertControllerManager.createDeleteAlert(), animated: true, completion: nil)
    }
    
    private func showActivityController(with text: String) {
        present(activityControllerManager.showActivity(textToShare: text),
                animated: true,
                completion: nil)
    }
    
    // MARK: - Action Methods

    @objc private func addDiary() {
        navigationController?.pushViewController(DiaryFormViewController(), animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CustomDiaryCell = tableView.dequeueReusableCell(
            withIdentifier: CustomDiaryCell.identifier,
            for: indexPath
        ) as? CustomDiaryCell else {
            return UITableViewCell()
        }
        
        let diary = diaries[indexPath.row]
        
        cell.configureCell(with: diary)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = diaries[indexPath.row]
        
        navigationController?.pushViewController(
            DiaryFormViewController(diary: diary),
            animated: true
        )
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt
                   indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "Share") { _, _, _ in
            let diary = self.diaries[indexPath.row]
            
            self.showActivityController(with: diary.totalText)
        }
        share.backgroundColor = .systemBlue
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.showDeleteAlert()
        }
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}

// MARK: - CoreData Methods

extension MainViewController {
    func readCoreData() -> [Entity]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entity>(entityName: "Entity")
        let result = try? managedContext.fetch(fetchRequest)
        
        return result
    }
}

// MARK: - NameSpace

private enum NameSpace {
    static let navigationTitle = "일기장"
    static let assetName = "sample"
}
