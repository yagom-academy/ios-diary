//
//  BaseTextView.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import UIKit

final class ContentTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTextView() {
        inputAccessoryView = makeToolBar()
        autocorrectionType = .no
        spellCheckingType = .no
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
            image: UIImage(systemName: AppConstants.keyboardHideButtonImage),
            style: .plain,
            target: self,
            action: #selector(didTapHideButton)
        )
        
        toolBar.items = [flexible, barButton]
        toolBar.clipsToBounds = true
        return toolBar
    }
    
    @objc private func didTapHideButton() {
        self.resignFirstResponder()
    }
}
