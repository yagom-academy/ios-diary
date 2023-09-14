//
//  Diary - DiaryListViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//  Last modified by Maxhyunm, Hamg.

import UIKit
import CoreLocation

final class DiaryListViewController: UIViewController {
    private var locationManager = CLLocationManager()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let dateFormatter = DateFormatter()
    private let container = CoreDataManager.shared.persistentContainer
    private var diaryList = [Diary]()
    
    private var latitude: Double?
    private var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        updateLocation()
        configureUI()
        setupNavigationBarButton()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readCoreData()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        self.title = "일기장"
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func setupNavigationBarButton() {
        let addDiary = UIAction(image: UIImage(systemName: "plus")) { [weak self] _ in
            guard let self else { return }
            let createDiaryView = DiaryDetailViewController(latitude: self.latitude, longitude: self.longitude)
            self.navigationController?.pushViewController(createDiaryView, animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(primaryAction: addDiary)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DiaryListTableViewCell.self, forCellReuseIdentifier: DiaryListTableViewCell.identifier)
    }
}

extension DiaryListViewController: AlertDisplayable {
    private func readCoreData() {
        do {
            let fetchedDiaries = try CoreDataManager.shared.fetchDiary()
            diaryList = fetchedDiaries.filter { $0.title != nil }
            tableView.reloadData()
        } catch CoreDataError.dataNotFound {
            let cancelAction = UIAlertAction(title: ButtonNamespace.confirm, style: .cancel)
            showAlert(title: CoreDataError.dataNotFound.alertTitle,
                      message: CoreDataError.dataNotFound.message,
                      actions: [cancelAction],
                      preferredStyle: .alert)
        } catch {
            let cancelAction = UIAlertAction(title: ButtonNamespace.confirm, style: .cancel)
            showAlert(title: CoreDataError.dataNotFound.alertTitle,
                      message: CoreDataError.unknown.message,
                      actions: [cancelAction],
                      preferredStyle: .alert)
        }
    }
}

extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryListTableViewCell.identifier,
                                                       for: indexPath) as?
                DiaryListTableViewCell else { return UITableViewCell() }
        
        let diaryEntity = diaryList[indexPath.row]
        guard let title = diaryEntity.title,
              let createdAt = diaryEntity.createdAt,
              let body = diaryEntity.body?.split(separator: "\n").joined(separator: "\n") else {
            return UITableViewCell()
        }
        let date = dateFormatter.formatToString(from: createdAt, with: "YYYY년 MM월 dd일")
        
        cell.setModel(title: title, date: date, body: body, icon: diaryEntity.weatherIcon)
        
        return cell
    }
}

extension DiaryListViewController: UITableViewDelegate, ShareDisplayable {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let diaryToEdit = diaryList[indexPath.row]
        let createVC = DiaryDetailViewController(diaryToEdit)
        
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
    UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let selectedDiary = self.diaryList[indexPath.row]
            do {
                try CoreDataManager.shared.deleteDiary(selectedDiary)
                self.readCoreData()
                success(true)
            } catch CoreDataError.deleteFailure {
                let cancelAction = UIAlertAction(title: ButtonNamespace.confirm, style: .cancel)
                self.showAlert(title: CoreDataError.deleteFailure.alertTitle,
                               message: CoreDataError.deleteFailure.message,
                               actions: [cancelAction],
                               preferredStyle: .alert)
            } catch {
                let cancelAction = UIAlertAction(title: ButtonNamespace.confirm, style: .cancel)
                self.showAlert(title: CoreDataError.deleteFailure.alertTitle,
                               message: CoreDataError.unknown.message,
                               actions: [cancelAction],
                               preferredStyle: .alert)
            }
        }
        
        let share = UIContextualAction(style: .normal, title: "") { (_, _, success: @escaping (Bool) -> Void) in
            let selectedDiary = self.diaryList[indexPath.row]
            
            self.shareDiary(selectedDiary)
            success(true)
        }
        
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash.fill")
        share.backgroundColor = .systemBlue
        share.image = UIImage(systemName: "square.and.arrow.up")
        
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
}

extension DiaryListViewController: CLLocationManagerDelegate {
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func updateLocation() {
        let locationStatus: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse]
        
        guard locationStatus.contains(locationManager.authorizationStatus) else { return }
        
        locationManager.startUpdatingLocation()
        
        guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        
        latitude = location.latitude
        longitude = location.longitude
    }
}
