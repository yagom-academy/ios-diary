//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit
import CoreData

final class AddDiaryViewController: UIViewController, AddKeyboardNotification {
    private let addDiaryView = AddDiaryView()
    
    override func loadView() {
        self.view = addDiaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = DateFormatter().longDate
        self.view.backgroundColor = UIColor.white
        self.setKeyboardObserver()
        self.initializeHideKeyBoard()
        
        addNewDiary()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardHeight = getKeyboardHeight(from: notification) else { return }
        
        self.addDiaryView.changeTextViewContentInset(for: keyboardHeight)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let keyboardHeight = getKeyboardHeight(from: notification) else { return }
        
        self.addDiaryView.changeTextViewContentInset(for: -keyboardHeight)
    }
    
    private func initializeHideKeyBoard() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self,
                                                              action: #selector(self.dismissKeyBoard))
        self.navigationController?.navigationBar.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyBoard() {
        self.addDiaryView.endEditing(true)
    }
    
    func createDiaryModel() -> DiaryModel {
        // title, body, createdAt 데이터 가져오기
        return DiaryModel(title: "", body: "", createdAt: 1)
    }
    
    func addNewDiary() {
        let diaryModel = createDiaryModel()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Diary", in: context)
        
        if let entity = entity {
            let newDiary = NSManagedObject(entity: entity, insertInto: context)
            newDiary.setValue(diaryModel.title, forKey: "title")
            newDiary.setValue(diaryModel.body, forKey: "body")
            newDiary.setValue(diaryModel.createdAt, forKey: "createdAt")
            newDiary.setValue(diaryModel.id, forKey: "id")
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
