//
//  DiaryViewController.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/28.
//

import UIKit

final class DiaryViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        
        return collectionView
    }()
    private var diaryDataSource: UICollectionViewDiffableDataSource<Section, Diary>?
    private var useCase: DiaryViewControllerUseCase?
    
    init(useCase: DiaryViewControllerUseCase) {
        self.useCase = useCase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupObject()
        configureUI()
        setupConstraint()
        configureDataSource()
        loadData()
        applySnapshot()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        applySnapshot()
    }
}

// MARK: Setup Object
extension DiaryViewController {
    private func setupObject() {
        setupView()
        setupNavigationBar()
        setupUseCase()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        let selectDateButton = UIBarButtonItem(
            image: UIImage(systemName: NameSpace.plusButtonImage),
            style: .plain,
            target: self,
            action: #selector(didTapSelectPlusButton)
        )
        navigationItem.title = NameSpace.diaryTitle
        navigationItem.rightBarButtonItem = selectDateButton
    }
    
    private func setupUseCase() {
        useCase?.delegate = self
    }
}

// MARK: Configure UI
extension DiaryViewController {
    private func configureUI() {
        configureView()
    }
    
    private func configureView() {
        view.addSubview(collectionView)
    }
}

// MARK: Setup Constraints
extension DiaryViewController {
    private func setupConstraint() {
        setupCollectionViewConstraint()
    }
    
    private func setupCollectionViewConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}

// MARK: Load Data
extension DiaryViewController {
    private func loadData() {
        useCase?.fetchDiaryList()
    }
}

// MARK: CollectionView Delegate
extension DiaryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let diary = useCase?.diaryList[safe: indexPath.item],
              let diaryPersistentManager =  useCase?.diaryPersistentManager else {
            return
        }
        
        let diaryDetailViewControllerUseCase = DiaryDetailViewControllerUseCase(diary: diary, diaryPersistentManager: diaryPersistentManager)
        let diaryDetailViewController = DiaryDetailViewController(useCase: diaryDetailViewControllerUseCase)
        
        show(diaryDetailViewController, sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: CollectionView DataSource
extension DiaryViewController {
    private func configureDataSource() {
        let registration = UICollectionView.CellRegistration<DiaryCollectionViewListCell, Diary> { cell, _, diary in
            cell.setupLabels(diary)
        }
        diaryDataSource = UICollectionViewDiffableDataSource<Section, Diary>(collectionView: collectionView) { collectionView, indexPath, diary in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: diary)
        }
    }
    
    private func applySnapshot() {
        guard let diaryList = useCase?.diaryList, let diaryDataSource else {
            return
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(diaryList)
        diaryDataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: CollectionView Layout
extension DiaryViewController {
    private func listLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath,
              let diary = diaryDataSource?.itemIdentifier(for: indexPath) else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            self.showDeleteAlert(diary)
        }
        let shareAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            self.showActivityView(for: indexPath)
        }
        deleteAction.image = UIImage(systemName: NameSpace.deleteImageName)
        shareAction.image = UIImage(systemName: NameSpace.shareImageName)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
    
    private func showActivityView(for indexPath: IndexPath?) {
        guard let indexPath = indexPath,
              let diary = diaryDataSource?.itemIdentifier(for: indexPath),
              let text = useCase?.readDiary(diary) else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { _, _, _, error in
            if let error {
                self.showErrorAlert(error: error)
            }
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: CollectionView Section
extension DiaryViewController {
    private enum Section {
        case main
    }
}

// MARK: Alert Action
extension DiaryViewController: DiaryViewControllerUseCaseDelegate {
    func showErrorAlert(error: Error) {
        let alertAction = UIAlertAction(title: NameSpace.check, style: .default)
        let alert = UIAlertController.customAlert(
            alertTile: NameSpace.error,
            alertMessage: error.localizedDescription,
            preferredStyle: .alert,
            alertActions: [alertAction]
        )
        
        navigationController?.present(alert, animated: true)
    }
    
    private func showDeleteAlert(_ diary: Diary) {
        let cancelAction = UIAlertAction(title: NameSpace.cancel, style: .default)
        let deleteAction = UIAlertAction(title: NameSpace.delete, style: .destructive) { _ in
            self.useCase?.delete(diary)
            self.loadData()
            self.applySnapshot()
        }
        let alert = UIAlertController.customAlert(
            alertTile: NameSpace.deleteTitle,
            alertMessage: NameSpace.deleteSubtitle,
            preferredStyle: .alert,
            alertActions: [cancelAction, deleteAction]
        )
        
        navigationController?.present(alert, animated: true)
    }
}

// MARK: Button Action
extension DiaryViewController {
    @objc private func didTapSelectPlusButton() {
        guard let diary = useCase?.newDiary(),
              let diaryPersistentManager =  useCase?.diaryPersistentManager else {
            return
        }
        
        let diaryDetailViewControllerUseCase = DiaryDetailViewControllerUseCase(diary: diary, diaryPersistentManager: diaryPersistentManager)
        let diaryDetailViewController = DiaryDetailViewController(useCase: diaryDetailViewControllerUseCase)
        
        show(diaryDetailViewController, sender: self)
    }
}

// MARK: Name Space
extension DiaryViewController {
    private enum NameSpace {
        static let diaryTitle = "일기장"
        static let plusButtonImage = "plus"
        static let check = "확인"
        static let error = "Error"
        static let deleteTitle = "진짜요?"
        static let deleteSubtitle = "정말로 삭제하시겠습니까?"
        static let cancel = "취소"
        static let delete = "삭제"
        static let deleteImageName = "trash.fill"
        static let shareImageName = "square.and.arrow.up"
    }
}
