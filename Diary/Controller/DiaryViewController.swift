//
//  DiaryViewController.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/21.
//

import UIKit
import CoreLocation

final class DiaryViewController: UIViewController {
    private var diary: Diary

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().localeFormattedText

        return label
    }()

    let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    private lazy var navigationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherIconImageView, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill

        return stackView
    }()

    private let scrollView: DiaryScrollView = {
        let scrollView = DiaryScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        scrollView.keyboardDismissMode = .interactive

        return scrollView
    }()

    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .title3)

        return textView
    }()

    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)

        return textView
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleTextView, bodyTextView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    init(diary: Diary, authorizationStatus: CLAuthorizationStatus? = nil) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCoreDataIfNeeded),
                                               name: UIScene.willDeactivateNotification,
                                               object: nil)

        if let status = authorizationStatus {
            fetchWeather(authorizationStatus: status)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureHierarchy()
        configureView(with: diary)
        configureLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        updateCoreDataIfNeeded()
    }

    private func fetchWeather(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            NetworkManager.shared.fetchWeather { result in
                switch result {
                case .success(let weatherResponseDTO):
                    let weather = weatherResponseDTO.toDomain()
                    self.diary.weather = weather
                    NetworkManager.shared.fetchWeatherIconImage(icon: weather.icon) { result in
                        switch result {
                        case .success(let weatherImage):
                            DispatchQueue.main.async {
                                self.weatherIconImageView.image = weatherImage
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        default:
            break
        }
    }

    private func configureHierarchy() {
        scrollView.addSubview(containerStackView)
        view.addSubview(scrollView)
        titleTextView.delegate = self
        bodyTextView.delegate = self
    }

    private func makeEllipsisMenu() -> UIMenu {
        let diary = diary
        let shareAction = UIAction(title: "공유",
                                   image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
            self?.showActivityViewController(diary: diary)
        }
        let deleteAction = UIAction(title: "삭제",
                                    image: UIImage(systemName: "trash"),
                                    attributes: .destructive) { [weak self] _ in
            self?.showDeleteActionAlert(diary: diary) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAction(title: "취소",
                                    image: UIImage(systemName: "xmark")) { _ in }
        let menu = UIMenu(identifier: nil,
                          options: .displayInline,
                          children: [shareAction, deleteAction, cancelAction])

        return menu
    }

    private func configureNavigationBar() {
        navigationItem.titleView = navigationStackView
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                            menu: makeEllipsisMenu())
    }

    private func configureView(with diary: Diary) {
        titleTextView.text = diary.title
        bodyTextView.text = diary.body
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            containerStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor)
        ])
    }

    private func generateDiary() -> Diary {
        return Diary(title: titleTextView.text,
                     body: bodyTextView.text,
                     createdAt: diary.createdAt,
                     uuid: diary.uuid,
                     weather: diary.weather)
    }

    @objc
    func updateCoreDataIfNeeded() {
        if diary.title != titleTextView.text || diary.body != bodyTextView.text {
            diary = generateDiary()
            CoreDataManager.shared.update(diary: diary)
        }
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n", textView == titleTextView {
            bodyTextView.becomeFirstResponder()
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updateCoreDataIfNeeded()
    }
}

extension DiaryViewController: DiaryPresentable {}
