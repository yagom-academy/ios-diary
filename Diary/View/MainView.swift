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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let baseTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func addSubviews() {
        addSubview(baseTableView)
    }
}
