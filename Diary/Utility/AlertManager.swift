//
//  AlertManager.swift
//  Diary
//
//  Created by Christy, vetto on 2023/05/04.
//

import UIKit

struct AlertManager {
    static let shared = AlertManager()
    
    private init() {}
    
    func alert(target: UIViewController, id: UUID) {
        let alert = UIAlertController(title: "진짜요?",
                                      message: "정말로 삭제하시겠어요?",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            CoreDataManger.shared.deleteDiary(id: id)
            target.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        target.present(alert, animated: true)
    }
}
