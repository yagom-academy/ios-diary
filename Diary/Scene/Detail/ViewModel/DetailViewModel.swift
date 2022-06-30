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
    private(set) var error: Observable<DiaryError>?
    
    init(diary: DiaryEntity) {
        self.diary = diary
    }
}

extension DetailViewModel {
    
    // MARK: Input
    
    func viewDidDisappear() {
        saveDiary()
    }
    
    func didEnterBackground() {
        saveDiary()
    }
    
    func keyboardWillHide() {
        saveDiary()
    }
    
    func textViewDidChange(text: String) {
        currentText = text
    }
    
    func didTapDeleteButton() {
        deleteDiary()
    }
    
    // MARK: Output
    
    private func saveDiary() {
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
        
        do {
            try PersistenceManager.shared.updateData(by: diary)
        } catch {
            self.error?.value = .saveFail
        }
    }
    
    private func deleteDiary() {
        do {
            try PersistenceManager.shared.deleteData(by: diary)
            status = .delete
        } catch {
            self.error?.value = .deleteFail
        }
    }
}
