//
//  MainViewModel.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit


final class MainViewModel: NSObject {
    private(set) var data: [DiaryInfo] = []
    
    func loadData() {
        guard let sample = NSDataAsset.init(name: "sample") else {
            return
        }
        let jsonDecoder = JSONDecoder()

        do {
            let data = try jsonDecoder.decode([DiaryInfo].self, from: sample.data)
            self.data = data
        } catch {
            print(error.localizedDescription)
        }
    }
}
