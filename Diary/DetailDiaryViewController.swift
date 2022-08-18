//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/18.
//

import UIKit

class DetailDiaryViewController: UIViewController {
    var content: DiarySample?
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()
    
    init(content: DiarySample? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.content = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItemTitle()
        configureUI()
        setComponents()
    }
    
    private func setNavigationItemTitle() {
        let time = content?.createdAt ?? Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: time)
        navigationItem.title = DateFormatter().format(data: date)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        self.view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setComponents() {
        guard let content = content else {
            return
        }

        textView.text = content.title + "\n\n" + content.body
        textView.contentOffset.y = 0
    }
}
