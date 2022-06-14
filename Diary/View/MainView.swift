//
//  MainView.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import UIKit

final class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    private let baseTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func setUpView() {
        addSubviews()
        makeConstraints()
        backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        addSubview(baseTableView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            baseTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            baseTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            baseTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            baseTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
