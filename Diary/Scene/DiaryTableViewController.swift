//
//  Diary - DiaryTableViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

extension DiaryTableViewController {
    static func instance(persistentManager: PersistentManager) -> DiaryTableViewController {
        return DiaryTableViewController(persistentManager: persistentManager)
    }
}

final class DiaryTableViewController: UITableViewController {
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Diary>
    private typealias DataSource = UITableViewDiffableDataSource<Int, Diary>
    
    private var dataSource: DataSource?
    private let persistentManager: PersistentManager!
    
    private let locationManager = CLLocationManager()

    private var diarys = [Diary]() {
        didSet {
            applySnapshot()
        }
    }
    
    init(persistentManager: PersistentManager) {
        self.persistentManager = persistentManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
        
    private func create() {
        let newDiary = Diary(title: "", body: "", createdDate: Date.now)
        diarys.insert(newDiary, at: .zero)
        persistentManager.create(data: newDiary)
    }
    
    private func read() {
        guard let results = persistentManager.fetchAll() else { return }
        
        diarys = results.map { entity in
            return Diary(title: entity.title, body: entity.body, createdDate: entity.createdDate, id: entity.id)
        }
    }
    
    private func find(id: String) -> Int? {
        return diarys.firstIndex { $0.id == id }
    }

    @objc
    private func addButtonDidTap() {
        create()
        guard let diary = diarys.first else { return }
        
        let diaryViewController = DiaryDetailViewController.instance(diary: diary)
        diaryViewController.delegate = self
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
}

// MARK: - TableViewDelegate

extension DiaryTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diary = diarys[indexPath.row]
        let diaryViewController = DiaryDetailViewController.instance(diary: diary)
        diaryViewController.delegate = self
        
        navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    override func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        return ContextualActionBuilder()
            .addAction(
                title: "삭제",
                image: UIImage(systemName: "trash.circle"),
                style: .destructive,
                action: { [weak self] in
                    guard let diary = self?.diarys[indexPath.row] else { return }
                    self?.delete(diary: diary)
                })
            .addAction(
                title: "공유",
                backgroundColor: .systemBlue,
                image: UIImage(systemName: "square.and.arrow.up.circle"),
                style: .normal,
                action: { [weak self] in
                    guard let diary = self?.diarys[indexPath.row] else { return }
                    
                    let text = diary.title + "\n\n" + diary.body
                    let activityViewController = UIActivityViewController(
                        activityItems: [text],
                        applicationActivities: nil
                    )
                    
                    self?.present(activityViewController, animated: true)
                })
            .build()
    }
}

// MARK: - CLLocationManagerDelegate

extension DiaryTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinator = locations.last?.coordinate {
            print(coordinator.longitude)
            print(coordinator.latitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - DiaryDetailViewDelegate

extension DiaryTableViewController: DiaryDetailViewDelegate {
    func update(diary: Diary) {
        guard let index = find(id: diary.id) else { return }
    
        diarys[index] = diary
        persistentManager.update(data: diary)
    }
    
    func delete(diary: Diary) {
        guard let index = find(id: diary.id) else { return }
    
        diarys.remove(at: index)
        persistentManager.delete(data: diary)
    }
}

// MARK: - SetUp

extension DiaryTableViewController {
    private func setUp() {
        setUpNavigationBar()
        setUpTableView()
        setUpLocationManager()
    }
    
    private func setUpNavigationBar() {
        title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonDidTap)
        )
    }
    
    private func setUpTableView() {
        tableView.separatorInset.left = 20
        tableView.register(DiaryCell.self, forCellReuseIdentifier: DiaryCell.reuseIdentifier)
        makeDataSource()
        read()
    }
    
    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func makeDataSource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DiaryCell.reuseIdentifier,
                for: indexPath
            ) as? DiaryCell
            
            cell?.setUpItem(with: item)
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(diarys)
        
        dataSource?.apply(snapshot)
    }
}
