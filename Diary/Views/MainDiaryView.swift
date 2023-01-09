//
//  MainDiaryView.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import UIKit

protocol SwipeConfigurable: AnyObject {
    func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration?
}

final class MainDiaryView: UIView {
    weak var delegate: SwipeConfigurable?
    var collectionView: UICollectionView! = nil
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure CollectionView
extension MainDiaryView {
    private func configureLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = .some({ indexPath in
            self.delegate?.makeSwipeActions(for: indexPath)
        })
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: configureLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
    }
}

// MARK: - UIConstraints
extension MainDiaryView {
    private func setupUI() {
        self.backgroundColor = .systemBackground
        configureCollectionView()
        self.addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
