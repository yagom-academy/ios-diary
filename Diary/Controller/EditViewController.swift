//
//  EditViewController.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/20.
//

import UIKit

final class EditViewController: DiaryViewController {
    init(diary: Diary?) {
        super.init(nibName: nil, bundle: nil)
        self.diary = diary
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }

    private func setInitialView() {
        setTitle()
        configureDiaryView()
    }
    
    private func setTitle() {
        guard let createdAt = diary?.createdAt else {
            return
        }
        
        if let iconImage = diary?.weather?.iconImage {
            let stackView = UIStackView()
            let imageView = UIImageView(image: UIImage(data: iconImage))
            let label = UILabel()
            label.text = Date(timeIntervalSince1970: createdAt).dateToKoreanString
            stackView.addArrangedSubview(([imageView, label]))
            self.navigationItem.titleView = stackView
        } else {
            self.title = Date(timeIntervalSince1970: createdAt).dateToKoreanString
        }
    }

    private func configureDiaryView() {
        guard let diary = diary else {
            return
        }
        
        diaryView.configureContents(diary: diary)
    }
}
