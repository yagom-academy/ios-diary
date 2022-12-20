//
//  DiaryListView.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/20.
//

import UIKit

final class DiaryListView: UIView {
    private var diaryListView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureListView()
        configureListViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureListView() {
        diaryListView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        diaryListView?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureListViewLayout() {
        guard let diaryListView = diaryListView else { return }
        self.addSubview(diaryListView)
        
        NSLayoutConstraint.activate([
            diaryListView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            diaryListView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            diaryListView.topAnchor.constraint(equalTo: self.topAnchor),
            diaryListView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
