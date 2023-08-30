//
//  DiaryManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/28.
//

import UIKit

protocol DiaryManagerDelegate {
    func showErrorAlert(error: Error)
}

struct DiaryManager {
    private(set) var diaryList: [Diary] = []
    var delegate: DiaryManagerDelegate?
    
    mutating func fetchDiaryList() {
        let dataManager = DataManager()
        let assetDataManager = AssetDataManager()
        
        do {
            let datas = try assetDataManager.fetchDiaryData()
            diaryList = dataManager.diary(diaryList: datas)
        } catch {
            delegate?.showErrorAlert(error: error)
        }
    }
}
