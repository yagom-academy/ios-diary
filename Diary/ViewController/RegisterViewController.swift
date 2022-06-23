//
//  RegisterViewController.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/17.
//

import UIKit

final class RegisterViewController: UIViewController {
    private let persistenceManager = PersistenceManager.shared
    private lazy var detailView = DetailView(frame: view.frame)

    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        createDiaryData()
    }
    
    private func createDiaryData() {
        let title = detailView.titleField.text
        let body = detailView.descriptionView.text
        persistenceManager.create(diary: DiaryModel(title: title, body: body, createdAt: Date(), id: UUID().uuidString))
    }
        )
    }
    
    }
    
    }
}
