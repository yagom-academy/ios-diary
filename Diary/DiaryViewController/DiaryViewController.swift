//
//  DiaryViewController.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/20.
//

import CoreData
import UIKit

final class DiaryViewController: UIViewController {
    private let container: NSPersistentContainer
    
    private let diaryView: DiaryView = DiaryView()
    private var diaryContents: [DiaryContent] = []

    override func loadView() {
        super.loadView()
        self.view = diaryView
    }

    init(with container: NSPersistentContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupDiaryContents()
        configureTableView()
        configureNavigationBar()
    }
    
    private func configureView() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func setupDiaryContents() {
        guard let contents = JSONDecoder.decode([DiaryContent].self, from: Constant.jsonAssetName) else { return }
        
        self.diaryContents = contents
    }
    
    private func configureTableView() {
        self.diaryView.configureTableView(delegate: self, dataSource: self)
    }

    private func configureNavigationBar() {
        self.navigationItem.title = Constant.diaryViewTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(tappedAddButton)
    }
    
    private func pushEditorViewControllerWith(_ container: NSPersistentContainer, _ content: DiaryContent? = nil) {
        let editorViewController = EditorViewController(with: content, container)
        
        self.navigationController?.pushViewController(editorViewController, animated: true)
    }
    
    @objc private func tappedAddButton(_ sender: UIBarButtonItem) {
        pushEditorViewControllerWith(self.container)
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        pushEditorViewControllerWith(self.container, diaryContents[indexPath.row])
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListCell.identifier) as? DiaryListCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: diaryContents[indexPath.row])
        return cell
    }
}
