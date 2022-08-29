//
//  Diary - DiaryListViewController.swift
//  Created by Hugh, Derrick on 2022/08/16.
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class DiaryListViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, DiaryContent>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, DiaryContent>
    
    enum Section {
        case main
    }

    private lazy var dataSource = self.configureDataSource()
    
    private var diaryViewModel: DiaryViewModelLogic?
    
    private let diaryListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DiaryTableViewCell.self, forCellReuseIdentifier: DiaryTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: DiaryViewModelLogic) {
        self.diaryViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefault()
        setupCoreLocation()
        configureLayout()
        initializeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        diaryViewModel?.fetch()
    }
    
    func initializeViewModel() {
        guard let data = diaryViewModel?.diaryContents else {
            return
        }
        updateDataSource(data: data)
        
        diaryViewModel?.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let data = self?.diaryViewModel?.diaryContents else {
                    return
                }
                
                self?.updateDataSource(data: data)
            }
        }
    }
    
    private func setupDefault() {
        self.view.backgroundColor = .white
        self.diaryListTableView.delegate = self
        
        self.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTappedAddButton))
    }
    
    private func setupCoreLocation() {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        guard let latitude = locationManager.location?.coordinate.latitude,
              let longitude = locationManager.location?.coordinate.longitude else {
            return
        }
        
        diaryViewModel?.requestLocation(latitude, with: longitude)
    }
        
    private func configureDataSource() -> DataSource {
        dataSource = DataSource(tableView: diaryListTableView, cellProvider: { tableView, indexPath, content -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTableViewCell.identifier, for: indexPath) as? DiaryTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configureUI(data: content)
            cell.accessoryType = .disclosureIndicator
            
            return cell
        })
        
        return dataSource
    }
    
    private func updateDataSource(data: [DiaryContent]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
    
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    private func configureLayout() {
        self.view.addSubview(diaryListTableView)
        
        NSLayoutConstraint.activate([
            diaryListTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            diaryListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            diaryListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            diaryListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
        
    @objc private func didTappedAddButton() {
        let addDiaryViewController = DiaryPostViewController()
        addDiaryViewController.diaryViewModel = diaryViewModel 
        
        self.navigationController?.pushViewController(addDiaryViewController, animated: true)
    }
}

// MARK: TableVeiwDelegate

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = diaryViewModel?.diaryContents?[indexPath.row] else {
            return
        }
        diaryViewModel?.createdAt = data.createdAt
        let diaryContentViewController = DiaryContentViewController()
        diaryContentViewController.diaryViewModel = diaryViewModel
        
        diaryContentViewController.configureUI(data: data)
        
        self.navigationController?.pushViewController(diaryContentViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "삭제") { [weak self](UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            guard let date = self?.diaryViewModel?.diaryContents?[indexPath.row].createdAt else {
                return
            }
            self?.diaryViewModel?.createdAt = date
            self?.diaryViewModel?.remove()
            success(true)
        }
        delete.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions:[delete])
    }
}
