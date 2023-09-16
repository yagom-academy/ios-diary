//
//  Diary - DiaryViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class DiaryViewController: UIViewController, Shareable {
    typealias Contents = String

    private var tableView = UITableView()
    private var diaryList = [Diary]()
    private var locationManager = CLLocationManager()
    private var latitude: Double?
    private var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDiary()
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let diary = diaryList[safe: indexPath.row] else {
            return
        }
        
        let diaryDetailViewController = DiaryDetailViewController(diary: diary)
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let diary = diaryList[safe: indexPath.row] else {
            return nil
        }
        
        let contents = "\(diary.title ?? "")\n\(diary.body ?? "")"
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            self?.diaryList.remove(at: indexPath.row)
            CoreDataManager.shared.delete(item: diary)
            tableView.reloadData()
        }
        let shareAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, _ in
            tableView.setEditing(false, animated: true)
            self?.showActivityView(data: contents, viewController: self)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.basic) as? DiaryCell,
              let diary = diaryList[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        let date = diary.date ?? Date()
        let formattedDate = DateFormatter.diaryFormatter.string(from: date)
        
        cell.configureCell(
            title: diary.title,
            date: formattedDate,
            preview: diary.body,
            icon: diary.icon
        )
        
        return cell
    }
}

private extension DiaryViewController {
    func loadDiary() {
        do {
            diaryList = try CoreDataManager.shared.read()
            tableView.reloadData()
        } catch {
            let alert = UIAlertController(title: nil, message: "Diary Data를 불러오지 못했습니다.", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
}

extension DiaryViewController: CLLocationManagerDelegate {
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            return
        }
        
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }
}

private extension DiaryViewController {
    func configure() {
        configureRootView()
        configureNavigation()
        configureTableView()
        registerCell()
        configureSubviews()
        configureConstraints()
    }
    
    func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigation() {
        let action = UIAction { [weak self] _ in
            let diary = CoreDataManager.shared.create()
            let diaryDetailViewController = DiaryDetailViewController(
                diary: diary,
                isUpdated: false,
                latitude: self?.latitude,
                longitude: self?.longitude
            )
            self?.navigationController?.pushViewController(diaryDetailViewController, animated: true)
        }
        
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: action)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func registerCell() {
        tableView.register(DiaryCell.self, forCellReuseIdentifier: CellIdentifier.basic)
    }
    
    func configureSubviews() {
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
