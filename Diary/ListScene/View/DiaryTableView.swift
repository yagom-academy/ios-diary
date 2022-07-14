//
//  DiaryTableView.swift
//  Diary
//
//  Created by 김태현 on 2022/06/28.
//

import UIKit

final class DiaryTableView: UITableView {
    init(delegate: UITableViewDelegate) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        
        setUpTableView(delegate: delegate)
        
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTableView(delegate: UITableViewDelegate) {
        translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
    }
    
    private func registerCell() {
        register(DiaryCell.self)
        register(UITableViewCell.self)
    }
    
    func layout(view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setUpTableView(refresh: UIRefreshControl) {
        refreshControl = refresh
    }
}
