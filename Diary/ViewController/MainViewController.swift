//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var sample: [Sample] = []
    let coreDataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        tableView.rowHeight = 55
        tableView.dataSource = self
        tableView.delegate = self
        decodeJSON()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callGetAllEntity()
    }
    
    private func callGetAllEntity() {
        coreDataManager.getAllEntity()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        guard let NewDetailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewController", creator: {coder in DetailViewController(entity: nil, coder: coder)}) else { return }
        
        self.navigationController?.pushViewController(NewDetailViewController, animated: true)
    }
    
    private func registerNib() {
        tableView.register(UINib(nibName: "DiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    private func decodeJSON() {
        let jsonDecoder = JSONDecoder()
        guard let dataAsset = NSDataAsset(name: "sample") else { return }
        
        do {
            self.sample = try jsonDecoder.decode([Sample].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coreDataManager.entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        let entity: Entity = self.coreDataManager.entities[indexPath.row]
        cell.configureLabel(entity: entity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity: Entity = self.coreDataManager.entities[indexPath.row]
        guard let detailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewController", creator: {coder in DetailViewController(entity: entity, coder: coder)}) else { return }
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, completion in
            let entity = self.coreDataManager.entities[indexPath.row]
            self.coreDataManager.deleteEntity(entity: entity)
            self.callGetAllEntity()
            completion(true)
        })
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
