//
//  UITableView+.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/27.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(cellType: Cell.Type, for indexPath: IndexPath) -> Cell
    where Cell: ReusableCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? Cell else {
            return Cell()
        }

        return cell
    }
}
