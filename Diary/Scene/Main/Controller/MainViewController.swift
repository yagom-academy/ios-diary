//
//  Diary - MainViewController.swift
//  Created by Quokka Taeangel.
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class MainViewController: UIViewController, CLLocationManagerDelegate {
  private lazy var baseView = ListView(frame: view.bounds)
  private let locationManager = CLLocationManager()
  private var diarys: [Diary]? {
    didSet {
      DispatchQueue.main.async {
        self.baseView.tableView.reloadData()
      }
    }
  }
  
  override func loadView() {
    super.loadView()
    view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    setlocationManager()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    diarys = DiaryData.read()
  }
  
  private func configureUI() {
    navigationItem.title = "일기장"
    navigationItem.rightBarButtonItem = createAddBarButtonItem()
    baseView.tableView.register(
      ListTableViewCell.self,
      forCellReuseIdentifier: ListTableViewCell.identifier)
    baseView.tableView.register(
      ListTableViewCell.self,
      forCellReuseIdentifier: EmptyTableViewCell.identifier)
    baseView.tableView.dataSource = self
    baseView.tableView.delegate = self
  }
  
  private func createAddBarButtonItem() -> UIBarButtonItem {
    return UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addButtonDidTap)
    )
  }
  
  @objc private func addButtonDidTap() {
    guard let lat = locationManager.location?.coordinate.latitude,
          let lon = locationManager.location?.coordinate.longitude else {
      return
    }
    let detailViewController = WriteViewController(latitude: lat, longitude: lon)
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  private func setlocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.stopUpdatingLocation()
  }
}

// MARK: TableViewDataSource

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return diarys?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: ListTableViewCell.identifier,
      for: indexPath) as? ListTableViewCell,
          let diary = diarys?[indexPath.row] else {
      return EmptyTableViewCell()
    }
    
    cell.update(diary: diary)
    
    return cell
  }
}

// MARK: TableViewDelegate

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let diary = diarys?[indexPath.row] else {
      return
    }
    let detailViewController = DetailViewController(diary: diary)
    
    self.navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .normal, title: "삭제") { _, _, completion in
      guard let identifier = self.diarys?[indexPath.row].identifier else {
        return
      }
      
      DiaryData.delete(identifier: identifier)
      self.diarys?.remove(at: indexPath.row)
      completion(true)
    }
    
    let shareAction = UIContextualAction(style: .normal, title: "공유") { _, _, completion in
      self.showActivityView(text: "공유")
      completion(true)
    }
    
    deleteAction.backgroundColor = .systemRed
    shareAction.backgroundColor = .systemBlue
    deleteAction.image = UIImage(systemName: "trash")
    shareAction.image = UIImage(systemName: "square.and.arrow.up")
    
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    configuration.performsFirstActionWithFullSwipe = false
    return configuration
  }
}
