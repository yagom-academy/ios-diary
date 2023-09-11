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
