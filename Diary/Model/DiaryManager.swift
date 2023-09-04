//
//  DiaryManager.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/28.
//

protocol DiaryManagerDelegate {
    func showErrorAlert(error: Error)
}

struct DiaryManager {
    private(set) var diaryList: [Diary] = []
    var delegate: DiaryManagerDelegate?
    
    mutating func fetchDiaryList() {
        let diaryDataManager = DiaryDataManager()
        let assetDataManager = AssetDataManager()
        
        do {
            let datas = try assetDataManager.fetchDiaryData()
            diaryList = diaryDataManager.diary(diaryList: datas)
        } catch {
            delegate?.showErrorAlert(error: error)
        }
    }
    
    func newDiary() -> Diary {
        let dateManager = DateManager()
        let diary = Diary(
            title: NameSpace.empty,
            body: NameSpace.empty,
            createdDate: dateManager.todayString()
        )
        
        return diary
    }
}

extension DiaryManager {
    private enum NameSpace {
        static let empty = ""
    }
}
