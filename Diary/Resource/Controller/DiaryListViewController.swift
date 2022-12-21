//
//  DiaryListViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

final class DiaryListViewController: UIViewController {
    private let diaryListTableView = UITableView()
    private var diaryForms: [DiaryForm] = []
    
    override func loadView() {
        view = diaryListTableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDiaryListTableView()
        fetchJSONData()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance =
        navigationController?.navigationBar.standardAppearance
        title = Namespace.navigationTitle
        
        let rightBarButtonImage = UIImage(systemName: Namespace.plusImage)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tappedPlusButton))
    }
    
    @objc private func tappedPlusButton(_ sender: UIBarButtonItem) {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    private func configureDiaryListTableView() {
        diaryListTableView.dataSource = self
        diaryListTableView.delegate = self
    }
    
    private func fetchJSONData() {
        guard let data = JSONDecoderManager().convertJSONData() else {
            showAlert(title: AlertNamespace.jsonDecodingErrorTitle,
                                message: AlertNamespace.jsonDecodingErrorMessage)
            return
        }
        
        diaryForms = data
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryForms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        diaryListTableView.register(DiaryListTableViewCell.self,
                                    forCellReuseIdentifier: DiaryListTableViewCell.identifier)
        
        guard let cell = diaryListTableView.dequeueReusableCell(
            withIdentifier: DiaryListTableViewCell.identifier,
            for: indexPath
        ) as? DiaryListTableViewCell else { return UITableViewCell() }
        
        cell.updateContent(data: diaryForms[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate { }

// MARK: Namespace
fileprivate enum Namespace {
    static let jsonData = "sample"
    static let navigationTitle = "일기장"
    static let plusImage = "plus"
}
