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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureJSONData()
        configureNavigationBar()
        self.view = diaryListTableView
        self.diaryListTableView.delegate = self
        self.diaryListTableView.dataSource = self
    }

    private func configureJSONData() {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        
        guard let dataAsset: NSDataAsset = NSDataAsset(name: Namespace.jsonData) else { return }
        
        do {
            diaryForms = try jsonDecoder.decode([DiaryForm].self, from: dataAsset.data)
        } catch {
            showAlertController(title: AlertNamespace.jsonErrorMessage, message: AlertNamespace.none)
        }
        
        self.diaryListTableView.reloadData()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.scrollEdgeAppearance =
            navigationController?.navigationBar.standardAppearance
        self.title = Namespace.navigationTitle
        
        let rightBarButtonImage = UIImage(systemName: Namespace.plusImage)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(tappedPlusButton))
    }
    
    @objc private func tappedPlusButton(_ sender: UIBarButtonItem) {
        let registerViewController = RegisterViewController()
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryForms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.diaryListTableView.register(DiaryListTableViewCell.self,
                                         forCellReuseIdentifier: DiaryListTableViewCell.identifier)
        
        guard let cell = diaryListTableView.dequeueReusableCell(
            withIdentifier: DiaryListTableViewCell.identifier,
            for: indexPath
        ) as? DiaryListTableViewCell else { return UITableViewCell() }
        
        cell.diaryForm = diaryForms[indexPath.row]
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
