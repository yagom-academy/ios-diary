//
//  DiaryTableViewDataSource.swift
//  Diary
//
//  Created by dudu, papri on 15/06/2022.
//

import UIKit

final class DiaryTableViewDataSource: UITableViewDiffableDataSource<Int, Diary> {
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Diary>
    
    private(set) var diarys = [Diary]() {
        didSet {
            makeSnapshot()
        }
    }
    
    private func makeSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(diarys)
        
        apply(snapshot)
    }
    
    func makeSampleDiarys() {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "json") else { return }
        
        do {
            let sampleData = try Data(contentsOf: url)
            diarys = try JSONDecoder().decode([Diary].self, from: sampleData)
        } catch {
            print(error)
        }
    }
}
