//
//  UIViewController+.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/21.
//

import UIKit

// MARK: - Activity
extension UIViewController {
    func showActivity(title: String?) {
        var shareObject = [Any]()
        
        if let shareText = title {
            shareObject.append(shareText)
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: shareObject,
            applicationActivities: nil
        )
                
        present(activityViewController, animated: true)
    }
}

// MARK: - Alert
extension UIViewController {
    private func deleteHandler(identifier: UUID) {
        DiaryDAO.shared.delete(identifier: identifier.uuidString)
    }
    
    func showActionSheet(
        shareTitle: String? = nil,
        identifer: UUID,
        deleteHandler: @escaping () -> Void
    ) {
        let share = UIAlertAction(title: "Share", style: .default) { [weak self] _ in
            self?.showActivity(title: shareTitle)
        }
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.showDeleteAlert(identifier: identifer, handler: deleteHandler)
        }
        
        let sheet = AlertBuilder.shared
            .setType(.actionSheet)
            .setAction(share)
            .setAction(UIAlertAction(title: "Cancel", style: .cancel))
            .setAction(delete)
            .build()
        
        present(sheet, animated: true)
    }
    
    func showDeleteAlert(identifier: UUID?, handler: @escaping () -> Void) {
        guard let identifier = identifier else {
            return
        }

        let action = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteHandler(identifier: identifier)
            handler()
        }
        
        let alert = AlertBuilder.shared
            .setTitle("진짜요?")
            .setMessage("정말로 삭제하시겠어요?")
            .setType(.alert)
            .setAction(UIAlertAction(title: "Cancel", style: .cancel))
            .setAction(action)
            .build()
        
        present(alert, animated: true)
    }
}

final class AlertBuilder {
    struct Product {
        var title: String?
        var message: String?
        var type: UIAlertController.Style = .alert
        var actions: [UIAlertAction] = []
    }
    
    static private let alertBuilder = AlertBuilder()
    static private var product = Product()
    
    static var shared: AlertBuilder {
        product = Product()
        return alertBuilder
    }

    private init() { }

    func setTitle(_ title: String) -> Self {
        Self.product.title = title
        
        return self
    }

    func setMessage(_ message: String) -> Self {
        Self.product.message = message
        
        return self
    }
    
    func setType(_ type: UIAlertController.Style) -> Self {
        Self.product.type = type
        
        return self
    }
    
    @discardableResult
    func setAction(_ action: UIAlertAction) -> Self {
        Self.product.actions.append(action)
        
        return self
    }
    
    func build() -> UIAlertController {
        let alert = UIAlertController(
            title: AlertBuilder.product.title,
            message: AlertBuilder.product.message,
            preferredStyle: AlertBuilder.product.type
        )
        
        AlertBuilder.product.actions.forEach {
            alert.addAction($0)
        }
        
        return alert
    }
}
