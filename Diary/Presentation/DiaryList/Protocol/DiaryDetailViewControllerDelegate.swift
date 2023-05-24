//
//  DiaryDetailViewControllerDelegate.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/05/03.
//

protocol DiaryDetailViewControllerDelegate: AnyObject {
    func createCell(contents: Contents)
    func updateCell(contents: Contents)
    func deleteCell()
}
