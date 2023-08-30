//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    enum Section {
        case main
    }
    private var dairySamples: [DairySample] = []
    private var diffableDatasource: UITableViewDiffableDataSource<Section, DairySample>?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.allowsSelection = false
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decodeDairySample(filename: "sample")
        
        configureUI()
        setUpConstraints()
        setUpViewController()
        setUpTableViewDiffableDataSource()
        setUpTableViewDiffableDataSourceSnapShot()
    }

    private func configureUI() {
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "일기장"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(didTappedRightAddButton))
    }
    
    private func decodeDairySample(filename: String) {
        let jsonDecoder = JSONDecoder()
        guard let asset = NSDataAsset(name: filename) else { return }
        guard let data = try? jsonDecoder.decode([DairySample].self, from: asset.data) else { return }
        
        dairySamples = data
    }
    
    private func convertFormattedDate(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: date)
    }
}

// MARK: - TableViewDiffableDataSource
extension MainViewController {
    private func setUpTableViewDiffableDataSource() {
        diffableDatasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, diarySample in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            
            let formattedDate = self.convertFormattedDate(date: diarySample.date)
            cell.setUpContents(title: diarySample.title, date: formattedDate, body: diarySample.body)
            return cell
        })
    }
    
    private func setUpTableViewDiffableDataSourceSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, DairySample>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(dairySamples)
        diffableDatasource?.apply(snapShot)
    }
}

// MARK: - Button Action
extension MainViewController {
    @objc
    private func didTappedRightAddButton() {
        let addDairyViewController = AddDairyViewController(diaryTitle: "드라고요롱이마초미미진사오미",
                                                            diaryDescription: "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine.\n\nI am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet I feel that I never was a greater artist than now.\n\nWhen, while the lovely valley teems with vapour around me, and the meridian sun strikes the upper surface of the impenetrable foliage of my trees, and but a few stray gleams steal into the inner sanctuary, I throw myself down among the tall grass by the trickling stream; and, as I lie close to the earth, a thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath\n\nI am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet I feel that I never was a greater artist than now.\n\nWhen, while the lovely valley teems with vapour around me, and the meridian sun strikes the upper surface of the impenetrable foliage of my trees, and but a few stray gleams steal into the inner sanctuary, I throw myself down among the tall grass by the trickling stream; and, as I lie close to the earth, a thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath\n\nI am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet I feel that I never was a greater artist than now.\n\nWhen, while the lovely valley teems with vapour around me, and the meridian sun strikes the upper surface of the impenetrable foliage of my trees, and but a few stray gleams steal into the inner sanctuary, I throw myself down among the tall grass by the trickling stream; and, as I lie close to the earth, a thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath")
        
        navigationController?.pushViewController(addDairyViewController, animated: true)
    }
}
