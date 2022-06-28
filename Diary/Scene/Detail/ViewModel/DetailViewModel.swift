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
    private var currentText: String?
    
    init(diary: DiaryEntity) {
        self.diary = diary
    }
}

extension DetailViewModel {
    
    // MARK: Input
    
    func viewDidDisappear() throws {
        try saveDiary()
    }
    
    func didEnterBackground() throws {
        try saveDiary()
    }
    
    func keyboardWillHide() throws {
        try saveDiary()
    }
    
    func textViewDidChange(text: String) {
        currentText = text
    }
    
    func didTapDeleteButton() throws {
        try deleteDiary()
    }
    
    // MARK: Output
    
    private func saveDiary() throws {
        if status == .delete {
            return
        }
        
        guard let content = currentText else {
            return
        }

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
                
        try PersistenceManager.shared.updateData(by: diary)
    }
    
    private func deleteDiary() throws {
        try PersistenceManager.shared.deleteData(by: diary)
        status = .delete
    }
}
