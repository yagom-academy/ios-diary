//
//  BaseTextView.swift
//  Diary
//
//  Created by 조민호 on 2022/06/14.
//

import UIKit

final class BaseTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTextView()
    }
    
    private func setUpTextView() {
        inputAccessoryView = makeToolBar()
        autocorrectionType = .no
    }
    
    private func makeToolBar() -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(
            x: .zero,
            y: .zero,
            width: UIScreen.main.bounds.size.width,
            height: 44.0)
        )
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.down"),
            style: .plain,
            target: self,
            action: #selector(didTapHideButton)
        )
        
        toolBar.items = [flexible, barButton]
        toolBar.barTintColor = .white
        toolBar.clipsToBounds = true
        return toolBar
    }
    
    @objc func didTapHideButton() {
        self.resignFirstResponder()
    }
}
