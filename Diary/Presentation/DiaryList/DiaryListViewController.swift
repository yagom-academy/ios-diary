//
//  DiaryListViewController.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/24.
//

import UIKit

final class DiaryListViewController: UIViewController {
    private let tableView = UITableView()
    private var contentsList: [Contents]?
    private var selectedCellIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIOption()
        fetchContents()
        configureTableView()
    }
    
    private func configureUIOption() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(moveToAppendDiary))
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.register(ContentsTableViewCell.self, forCellReuseIdentifier: ContentsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchContents() {
        do {
            contentsList = try CoreDataManager.shared.read()
        } catch {
            AlertManager().showErrorAlert(target: self, error: error)
        }
    }
    
    @objc private func moveToAppendDiary() {
        let diaryDetailViewController = DiaryDetailViewController(contents: nil)
        
        diaryDetailViewController.delegate = self
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}

// MARK: - Table view data source
extension DiaryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsList?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ContentsTableViewCell.identifier,
            for: indexPath) as? ContentsTableViewCell else {
            return UITableViewCell()
        }
        
        guard let contents = contentsList?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(title: contents.title, description: contents.body, date: contents.localizedDate)
        
        guard let iconCode = contents.weather?.iconCode else {
            return cell
        }

        fetchWeatherImage(cell: cell, iconCode: iconCode)
        
        return cell
    }
    
    private func fetchWeatherImage(cell: ContentsTableViewCell, iconCode: String) {
        let endPoint = EndPoint.weatherImage(iconCode: iconCode).asURLRequest()
        
        NetworkManager().fetchData(urlRequest: endPoint) { [weak self, weak cell] result in
            guard let self else { return }

            switch result {
            case .success(let image):
                let iconImage = UIImage(data: image)

                DispatchQueue.main.async {
                    cell?.configure(iconImage: iconImage)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    AlertManager().showErrorAlert(target: self, error: error)
                }
            }
        }
    }
}

// MARK: - Table view delegate
extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contents = contentsList?[indexPath.row] else { return }
        
        selectedCellIndex = indexPath
        
        let diaryDetailViewController = DiaryDetailViewController(contents: contents)
        
        diaryDetailViewController.delegate = self
        navigationController?.pushViewController(diaryDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let contents = contentsList?[indexPath.row] else { return nil }
        selectedCellIndex = indexPath
        
        let share = UIContextualAction(style: .normal, title: "Share") { [weak self] _, _, _ in
            let activityViewController = UIActivityViewController(activityItems: [contents.title],
                                                                  applicationActivities: nil)
            
            self?.present(activityViewController, animated: true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let identifier = contents.identifier else { return }
            
            self?.showDeleteAlert(identifier: identifier)
        }
        
        share.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [share, delete])
    }
    
    private func showDeleteAlert(identifier: UUID) {
        AlertManager().showDeleteAlert(target: self) { [weak self] in
            do {
                try CoreDataManager.shared.delete(identifier: identifier)
                self?.deleteCell()
            } catch {
                guard let self else { return }
                
                AlertManager().showErrorAlert(target: self, error: error)
            }
        }
    }
}

// MARK: - DiaryDetailViewController Delegate
extension DiaryListViewController: DiaryDetailViewControllerDelegate {
    func createCell(contents: Contents) {
        guard let newIndexPathRow = contentsList?.count else { return }

        selectedCellIndex = IndexPath(row: newIndexPathRow, section: 0)
        
        guard let selectedCellIndex else { return }
        
        contentsList?.append(contents)
        tableView.insertRows(at: [selectedCellIndex], with: .automatic)
    }
    
    func updateCell(contents: Contents) {
        guard let selectedCellIndex else { return }
        
        contentsList?[selectedCellIndex.row] = contents
        tableView.reloadRows(at: [selectedCellIndex], with: .automatic)
    }
    
    func deleteCell() {
        guard let selectedCellIndex else { return }
        
        contentsList?.remove(at: selectedCellIndex.row)
        tableView.deleteRows(at: [selectedCellIndex], with: .fade)
        self.selectedCellIndex = nil
    }
}
