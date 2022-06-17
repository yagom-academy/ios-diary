//
//  SwipeActionBuilder.swift
//  Diary
//
//  Created by dudu, papri on 17/06/2022.
//

import UIKit

struct ContextualAction {
    let title: String?
    let backgroundColor: UIColor?
    let image: UIImage?
    let style: UIContextualAction.Style
    let action: (() -> Void)?
}

final class ContextualActionBuilder {
    private var contextualActions = [ContextualAction]()
    
    func addContextualAction(
        title: String? = nil,
        backgroundColor: UIColor? = nil,
        image: UIImage? = nil,
        style: UIContextualAction.Style,
        action: (() -> Void)?
    ) -> Self {
        contextualActions.append(
            ContextualAction(title: title, backgroundColor: backgroundColor, image: image, style: style, action: action)
        )
        
        return self
    }
    
    func make() -> UISwipeActionsConfiguration {
        let actions = contextualActions.map { action -> UIContextualAction in
            let contextualAction = UIContextualAction(style: action.style, title: action.title) { _, _, completion in
                action.action?()
                completion(true)
            }
            contextualAction.image = action.image
            contextualAction.backgroundColor = action.backgroundColor
            
            return contextualAction
        }
        
        return UISwipeActionsConfiguration(actions: actions)
    }
}
