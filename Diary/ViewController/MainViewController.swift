//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var sample: [Sample] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        tableView.rowHeight = 55
        tableView.dataSource = self
        tableView.delegate = self
        decodeJSON()
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        guard let newDiaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewDiaryViewController") else { return }
        
        self.navigationController?.pushViewController(newDiaryViewController, animated: true)
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
        return self.sample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DiaryTableViewCell else {
            return UITableViewCell()
        }
        
        let sample: Sample = self.sample[indexPath.row]
        cell.configureLabel(sample: sample)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sample: Sample = self.sample[indexPath.row]
        guard let detailViewController = self.storyboard?.instantiateViewController(identifier: "DetailViewController", creator: {coder in DetailViewController(sample: sample, coder: coder)}) else { return }
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

