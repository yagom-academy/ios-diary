//
//  String+Extension.swift
//  Diary
//
//  Created by leewonseok on 2022/12/28.
//
extension String {
    func sliceTitleAndContent() -> (String, String) {
        let title = self.components(separatedBy: "\n").filter { $0 != ""}.first ?? ""
        let content = self.components(separatedBy: "\n").filter { $0 != ""}[safe: 1] ?? ""
        return (title, content)
    }
}
