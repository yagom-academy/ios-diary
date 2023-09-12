//
//  AlertManager.swift
//  Diary
//
//  Created by 예찬 on 2023/09/11.
//

import UIKit

final class AlertManager: UIViewController {
    let uuid: UUID
    
    init(uuid: UUID) {
        self.uuid = uuid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
 
}
