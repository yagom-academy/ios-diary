//
//  DiaryFormViewController.swift
//  Diary
//  Created by inho, dragon on 2022/12/21.
//

import UIKit
import CoreData

final class DiaryFormViewController: UIViewController {
    // MARK: - Properties
    
    private let diaryFormView = DiaryFormView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureDiaryViewLayout()
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Private Methods
    
    private func configureDiaryViewLayout() {
        view.addSubview(diaryFormView)
        
        NSLayoutConstraint.activate([
            diaryFormView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryFormView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryFormView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryFormView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = DateFormatter.koreanDateFormatter.string(from: Date())
    }
    
    private func saveCoreData(diary: Diary) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(
            forEntityName: "Entity",
            in: managedContext) else {
            return
        }
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        object.setValue(diary.body, forKey: "body")
        object.setValue(diary.createdDate, forKey: "createdDate")
        object.setValue(diary.title, forKey: "title")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
