//
//  MainView.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/14.
//

import UIKit

final class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private func configureView() {
        self.addSubview(searchBar)
        self.addSubview(tableView)
        self.backgroundColor = .white

        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        addHideButtonOnKeyboard()
    }
    
    private func addHideButtonOnKeyboard() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(hideKeyboard))
        
        barButton.tintColor = .darkGray
        
        let emptySpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
        
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        toolBar.setItems([emptySpace, barButton], animated: false)
        
        searchBar.inputAccessoryView = toolBar
    }
    
    @objc private func hideKeyboard() {
        self.searchBar.endEditing(true)
    }
}
