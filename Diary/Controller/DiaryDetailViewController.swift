//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by hoon, karen on 2023/08/30.
//

import UIKit

final class DiaryDetailViewController: UIViewController, Shareable {
    typealias Contents = String
    
    private let diary: Diary
    private let isUpdated: Bool
    private var latitude: Double?
    private var longitude: Double?
    
    private let contentTextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.adjustsFontForContentSizeCategory = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.addDoneButtonOnKeyboard()

        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureToast()
        fetchWeather()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDiary()
    }
    
    init(diary: Diary, isUpdated: Bool = true, latitude: Double? = nil, longitude: Double? = nil) {
        self.diary = diary
        self.isUpdated = isUpdated
        self.latitude = latitude
        self.longitude = longitude
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveDiary()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveDiary()
    }
}

private extension DiaryDetailViewController {
    func saveDiary() {
        guard !contentTextView.text.isEmpty else {
            CoreDataManager.shared.delete(item: diary)
            return
        }
        
        let contents = contentTextView.text.split(separator: "\n")
        let title = String(contents[0])
        let body = contents.dropFirst().joined(separator: "\n")

        if contents.isEmpty {
            saveContents(title: "", body: "")
        } else {
            saveContents(title: title, body: body)
        }
    }
    
    func saveContents(title: String, body: String) {
        diary.setValue(title, forKeyPath: "title")
        diary.setValue(body, forKeyPath: "body")
        CoreDataManager.shared.update()
    }
}

private extension DiaryDetailViewController {
    func configure() {
        configureRootView()
        configureTextView()
        configureNavigation()
        configureSubviews()
        configureContents()
        configureKeyboard()
        configureConstraints()
    }
    
    func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    func configureTextView() {
        contentTextView.delegate = self
    }
    
    func configureNavigation() {
        let buttonImage = UIImage(systemName: "ellipsis.circle")
        let alert = configureAlert()
        let action = UIAction { [weak self] _ in
            self?.present(alert, animated: true)
        }
        
        navigationItem.title = DateFormatter.diaryFormatter.string(from: diary.date ?? Date())
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: buttonImage, primaryAction: action)
    }
    
    func configureAlert() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { [weak self] _ in
            guard let shareData = self?.contentTextView.text else {
                return
            }
            
            self?.showActivityView(data: shareData, viewController: self)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.showDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    func showDeleteAlert() {
        let alert = UIAlertController(
            title: "진짜요?",
            message: "정말로 삭제하시겠어요?",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.contentTextView.text = ""
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    func configureSubviews() {
        view.addSubview(contentTextView)
    }
    
    func configureContents() {
        guard isUpdated else {
            return
        }
        
        let title = diary.title ?? ""
        let body = diary.body ?? ""
        contentTextView.text = title + "\n" + body
    }
    
    func configureKeyboard() {
        if !isUpdated {
            contentTextView.becomeFirstResponder()
        }
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
}

extension DiaryDetailViewController: Toastable {
    func configureToast() {
        APIKey.delegate = self
    }
    
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(
            x: self.view.frame.size.width / 2 - 100,
            y: self.view.frame.size.height / 2 - 35,
            width: 200,
            height: 70
        ))
        
        toastLabel.backgroundColor = UIColor.systemGray
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.preferredFont(forTextStyle: .body)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

private extension DiaryDetailViewController {
    func fetchWeather() {
        guard let latitude, let longitude else {
            return
        }
        
        WeatherAPI.Users(
            host: HostName.localWeather.address,
            path: Path.localWeather.description,
            query: Query.localWeather(latitude: latitude, longitude: longitude).parameters
        ).request { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodedData: Location = try? DecodingManager.decodeData(from: data) else {
                    return
                }
                
                guard let currentWeather = decodedData.weather.first else {
                    return
                }
                
                self?.diary.main = currentWeather.main
                self?.diary.icon = currentWeather.icon
            case .failure(let error):
                print(error.description)
            }
        }
    }
}
