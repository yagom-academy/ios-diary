//
//  DiaryViewController.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/20.
//

import UIKit

final class DiaryViewController: UIViewController {
    private let diaryView: DiaryView = DiaryView()
    private var diaryContents: [DiaryContent] = []

    override func loadView() {
        super.loadView()
        self.view = diaryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupDiaryContents()
        configureTableView()
        configureNavigationBar()
    }
    
    private func setupDiaryContents() {
        guard let contents = JSONDecoder.decode([DiaryContent].self, from: "sample") else { return }
        
        self.diaryContents = contents
    }
    
    private func configureTableView() {
        diaryView.configureTableView(delegate: self, dataSource: self)
    }

    private func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(tappedAddButton)
    }

    @objc private func tappedAddButton(_ sender: UIBarButtonItem) {
        let editorViewController = EditorViewController()
        editorViewController.configureEditorView()
        
        self.navigationController?.pushViewController(editorViewController, animated: true)
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let editorViewController = EditorViewController()
        editorViewController.configureEditorView(from: diaryContents[indexPath.row])
        
        self.navigationController?.pushViewController(editorViewController, animated: true)
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
        cell.setupLabelText(from: diaryContents[indexPath.row])
        return cell
    }
}
