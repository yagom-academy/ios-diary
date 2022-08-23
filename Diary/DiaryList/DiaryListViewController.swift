//
//  Diary - DiaryListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class DiaryListViewController: UIViewController {
    // MARK: - Properties
    
    private let diaryListView = DiaryListView(frame: .zero)
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureDiaryListView()
        diaryListView.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        diaryListView.tableView.reloadData()
    }
    
    // MARK: - Methods
    
    private func configureNavigationBar() {
        navigationItem.title = NameSpace.diary
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonDidTapped))
    }
    
    private func configureDiaryListView() {
        view.addSubview(diaryListView)
        diaryListView.translatesAutoresizingMaskIntoConstraints = false
        diaryListView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        diaryListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        diaryListView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        diaryListView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func addButtonDidTapped() {
        navigationController?.pushViewController(DiaryViewController(), animated: true)
    }
}

// MARK: - UITableViewDelegate

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diaryViewController = DiaryViewController()
        let attributedString = setAttributedString(indexPath: indexPath.row)
        
        diaryViewController.diaryView.diaryTextView.text = nil
        diaryViewController.diaryView.diaryTextView.textColor = .black
        diaryViewController.diaryView.diaryTextView.attributedText = attributedString
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    private func setAttributedString(indexPath: Int) -> NSMutableAttributedString {
        guard let diaryTitle = CoreDataManager.shared.fetchedDiaries[indexPath].title,
              let diaryBody = CoreDataManager.shared.fetchedDiaries[indexPath].body else { return NSMutableAttributedString() }
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: diaryTitle, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)])
        
        attributedString.append(NSMutableAttributedString(string: "\n"))
        attributedString.append(NSMutableAttributedString(string: diaryBody, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]))
        
        return attributedString
    }
}
