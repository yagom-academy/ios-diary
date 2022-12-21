//
//  DiaryListView.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/20.
//

import UIKit

final class DiaryListView: UIView {
    var diaryList: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureListView()
        configureListViewLayout()
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureListView() {
        diaryList = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        diaryList?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureListViewLayout() {
        guard let diaryList = diaryList else { return }
        self.addSubview(diaryList)
        
        NSLayoutConstraint.activate([
            diaryList.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            diaryList.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            diaryList.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            diaryList.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
