//
//  NewDiaryViewController.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/30.
//

import UIKit
import CoreData

final class NewDiaryViewController: UIViewController {
    private var keyboardManager: KeyboardManager?
//    let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    var context = CoreDataManager.shared.context
    
    private let textView: UITextView = {
        let view: UITextView = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        view.alwaysBounceVertical = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        configureLayout()
        setUpKeyboardEvent()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: context) else {
            return
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue("a", forKey: "title")
        object.setValue("b", forKey: "body")
        object.setValue("c", forKey: "createdAt")
        
        do {
            try context.save()
            print("success")
        } catch {
            print(error)
        }
        do {
            let data = try context.fetch(Diary.fetchRequest())
            print(data)
        } catch {
            print(error)
        }
        
    }
    
    private func configureNavigation() {
        navigationItem.title = "DateFormatter.today"
    }
    
    private func configureUI() {
        view.addSubview(textView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setUpKeyboard() {
        keyboardManager = KeyboardManager(textView: textView)
    }
    
    private func setUpKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        keyboardFrame = textView.convert(keyboardFrame, from: nil)
        var contentInset = textView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        textView.contentInset = contentInset
        textView.verticalScrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func keyboardWillHide() {
        textView.contentInset = UIEdgeInsets.zero
        textView.verticalScrollIndicatorInsets = textView.contentInset

    }
}
