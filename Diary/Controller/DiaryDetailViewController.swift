//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/25.
//

import UIKit
import CoreLocation

final class DiaryDetailViewController: UIViewController {
    private var contents: ContentsDTO?
    private let locationManager = CLLocationManager()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    weak var delegate: DiaryDetailViewControllerDelegate?
    
    init(contents: ContentsDTO?) {
        self.contents = contents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocation()
        configureUIOption()
        configureTextView()
        configureLayout()
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveContents()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        textView.resignFirstResponder()
    }
    
    private func checkLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func fetchWeather(latitude: String, longitude: String) {
        let endPoint = EndPoint.weatherInfo(latitude: latitude, longitude: longitude).asURLRequest()
        
        NetworkManager().fetchData(urlRequest: endPoint) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                let weather = DecodeManager().decodeAPI(data: data, type: WeatherDTO.self)
                
                switch weather {
                case .success(let weather):
                    guard let iconCode = weather.weather.first?.iconCode else {
                        AlertManager().showErrorAlert(target: self, error: NetworkError.dataNotFound)
                        return
                    }
                    
                    self.fetchWeatherImage(iconCode: iconCode)
                case .failure(let error):
                    DispatchQueue.main.async {
                        AlertManager().showErrorAlert(target: self, error: error)
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    AlertManager().showErrorAlert(target: self, error: error)
                }
            }
        }
    }
    
    private func fetchWeatherImage(iconCode: String) {
        let endPoint = EndPoint.weatherImage(iconCode: iconCode).asURLRequest()
        
        NetworkManager().fetchData(urlRequest: endPoint) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.weatherIconImageView.image = UIImage(data: image)
                    self.navigationItem.titleView = self.createStackView()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    AlertManager().showErrorAlert(target: self, error: error)
                }
            }
        }
    }
    
    private func configureUIOption() {
        view.backgroundColor = .systemBackground
        dateLabel.text = contents?.localizedDate ?? Date().translateLocalizedFormat()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showActionSheet))
    }
    
    @objc private func showActionSheet() {
        textView.endEditing(true)
        guard let text = textView.text else { return }
        
        let alert = UIAlertController()
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let shareAction = UIAlertAction(title: "Share...", style: .default) { [weak self] _ in
            let activityViewController = UIActivityViewController(activityItems: [text],
                                                                  applicationActivities: nil)
            
            self?.present(activityViewController, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.showDeleteAlert()
        }
        
        alert.addAction(shareAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showDeleteAlert() {
        AlertManager().showDeleteAlert(target: self) { [weak self] in
            self?.deleteContents()
        }
    }
    
    private func configureTextView() {
        textView.delegate = self
        
        if let contents {
            textView.text = """
            \(contents.title)
            \(contents.body)
            """
        } else {
            textView.text = nil
            textView.becomeFirstResponder()
        }
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [weatherIconImageView, dateLabel])
        stackView.axis = .horizontal
        
        return stackView
    }
    
    private func configureLayout() {
        view.addSubview(textView)
        textView.contentOffset = .zero
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
        NSLayoutConstraint.activate([
            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textView.bottomAnchor),
            
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor)
        ])
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveContents),
            name: UIScene.didEnterBackgroundNotification,
            object: nil)
    }
}

// MARK: - Data CRUD
extension DiaryDetailViewController {
    @objc private func saveContents() {
        guard contents != nil else {
            createContents()
            return
        }
        
        updateContents()
    }
    
    private func updateContents() {
        let splitedContents = splitContents()
        
        contents?.title = splitedContents.title
        contents?.body = splitedContents.body
        
        guard let contents else { return }
        
        do {
            try CoreDataManager.shared.update(contents: contents)
            delegate?.updateCell(contents: contents)
        } catch {
            AlertManager().showErrorAlert(target: self, error: error)
        }
    }
    
    private func createContents() {
        let date = Date().timeIntervalSince1970
        let splitedContents = splitContents()
        
        guard splitedContents.title.isEmpty == false else { return }
        
        contents = ContentsDTO(title: splitedContents.title,
                            body: splitedContents.body,
                            date: date,
                            identifier: UUID())
        
        guard let contents else { return }
        
        do {
            try CoreDataManager.shared.create(contents: contents)
            delegate?.createCell(contents: contents)
        } catch {
            AlertManager().showErrorAlert(target: self, error: error)
        }
    }
        
    private func deleteContents() {
        guard let identifier = contents?.identifier else { return }
        
        do {
            try CoreDataManager.shared.delete(identifier: identifier)
            delegate?.deleteCell()
            
            navigationController?.popToRootViewController(animated: true)
        } catch {
            AlertManager().showErrorAlert(target: self, error: error)
        }
    }
    
    private func splitContents() -> (title: String, body: String) {
        let splitedText = textView.text.split(separator: "\n", maxSplits: 1)
        var title = ""
        var body = ""
        
        if splitedText.count == 1 {
            title = String(describing: splitedText[0])
        } else if splitedText.count == 2 {
            title = String(describing: splitedText[0])
            body = String(describing: splitedText[1])
        }
        
        return (title, body)
    }
}

// MARK: - Text view delegate
extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveContents()
    }
}

extension DiaryDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            fetchWeather(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude))
        }
    }
}
