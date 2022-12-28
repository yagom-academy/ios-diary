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
    private let selectedDiary: Diary?
    private let alertControllerManager = AlertControllerManager()
    private let activityControllerManager = ActivityControllerManager()
    
    // MARK: - Initializer
    
    init(diary: Diary? = nil) {
        selectedDiary = diary
        
        if let diary = diary {
            diaryFormView.diaryTextView.text = diary.totalText
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureDiaryViewLayout()
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        selectSaveOrUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        diaryFormView.diaryTextView.becomeFirstResponder()
    }
    
    // MARK: - Internal Methods
    
    func selectSaveOrUpdate() {
        let diary = createDiary()
        
        if selectedDiary != nil {
            updateCoreData(diary: diary)
        } else {
            if !diary.title.isEmpty, !diary.body.isEmpty {
                saveCoreData(diary: diary)
            }
        }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(showActionSheet)
        )
    }
    
    private func createDiary() -> Diary {
        var components = diaryFormView.diaryTextView.text.components(separatedBy: "\n")
        let title = components.removeFirst()
        let body = components.filter { !$0.isEmpty }.first ?? ""
        var uuid = UUID()
        if let id = selectedDiary?.id {
            uuid = id
        }
        
        let diary = Diary(title: title,
                          body: body,
                          createdAt: Int(Date().timeIntervalSince1970),
                          totalText: diaryFormView.diaryTextView.text,
                          id: uuid)

        return diary
    }
    
    private func showDeleteAlert() {
        present(alertControllerManager.createDeleteAlert(), animated: true, completion: nil)
    }
    
    private func showActivityController() {
        if let totalText = diaryFormView.diaryTextView.text, !totalText.isEmpty {
            present(activityControllerManager.showActivity(textToShare: totalText),
                    animated: true,
                    completion: nil)
        }
    }
    
    // MARK: - Action Methods
    
    @objc private func showActionSheet() {
        present(alertControllerManager.createActionSheet(shareHandler: showActivityController,
                                                         deleteHandler: showDeleteAlert),
                animated: true,
                completion: nil)
    }
}

// MARK: - CoreData Methods

extension DiaryFormViewController {
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
        object.setValue(diary.createdAt.description, forKey: "createdDate")
        object.setValue(diary.title, forKey: "title")
        object.setValue(diary.totalText, forKey: "totalText")
        object.setValue(diary.id, forKey: "id")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func updateCoreData(diary: Diary) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Entity")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", diary.id.uuidString)
        
        guard let result = try? managedContext.fetch(fetchRequest),
              let object = result[0] as? NSManagedObject else { return }
        
        object.setValue(diary.title, forKey: "title")
        object.setValue(diary.body, forKey: "body")
        object.setValue(diary.createdAt.description, forKey: "createdDate")
        object.setValue(diary.totalText, forKey: "totalText")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
}
