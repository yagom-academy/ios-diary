//
//  DetailViewModel.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/22.
//

final class DetailViewModel {
    private enum ExecutionStatus {
        case update
        case delete
    }
    
    private(set) var diary: DiaryEntity
    private var status: ExecutionStatus = .update
    
    init(diary: DiaryEntity) {
        self.diary = diary
    }
}

extension DetailViewModel {
    func saveDiary(text: String?) {
        if status == .delete {
            return
        }
        
        guard let content = text else { return }

        var splitedText = content.components(separatedBy: "\n")
        let title = splitedText.removeFirst()
        let body = splitedText.joined(separator: "\n")

        let diary = Diary(
            title: title,
            createdAt: diary.createdAt,
            body: body,
            id: diary.id,
            icon: diary.icon
        )
                
        PersistenceManager.shared.updateData(by: diary)
    }
    
    func deleteDiary() {
        PersistenceManager.shared.deleteData(by: diary)
        status = .delete
    }
}
