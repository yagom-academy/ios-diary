//  Diary - String+Extension.swift
//  Created by Ayaan, zhilly on 2022/12/21

extension String {
    func hasText() -> Bool {
        return self.filter({ $0.isLetter }).isEmpty == false
    }
}
