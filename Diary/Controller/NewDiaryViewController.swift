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
    private var today: String = ""
    private var tt: String = ""
    private var bd: String = ""
    private var ca: String = ""
    
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
        setUpKeyboard()
        textView.delegate = self
    }
    
    private func configureNavigation() {
        navigationItem.title = DateFormatter.today
        today = DateFormatter.today
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
}

extension NewDiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: CoreDataManager.shared.context) else {
            return
        }
        
        let object = NSManagedObject(entity: entity, insertInto: CoreDataManager.shared.context)
        object.setValue("타이틀틀틀", forKey: "title")
        object.setValue(textView.text, forKey: "body")
        object.setValue(today, forKey: "createdAt")
        object.setValue(UUID().uuidString, forKey: "identifier")
        tt = "타이틀틀틀"
        bd = textView.text
        ca = today
        saveCoreData()
    }
    
    func saveCoreData() {
        do {
            try CoreDataManager.shared.context.save()
            print("success")
        } catch {
            print(error.localizedDescription)
        }
    }
}
