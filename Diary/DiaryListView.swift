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
    }
}
