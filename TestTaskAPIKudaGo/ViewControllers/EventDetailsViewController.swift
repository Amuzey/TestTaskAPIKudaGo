//
//  EventDetailsViewController.swift
//  TestTaskAPIKudaGo
//
//  Created by Алексей on 15.05.2023.
//

import UIKit
import SnapKit

class EventDetailsViewController: UIViewController {
    //MARK: - Public properties
    var event: Event?
    
    //MARK: - Private properties
    private var networkService = NetworkService()
    private let imageView = UIImageView()
    private let eventTitle = UILabel()
    private let eventDescription = UILabel()
    private let eventDate = UILabel()
    private let activityIndicator = UIActivityIndicatorView()
    private lazy var urlImage = event?.images.first?.image
    
    //MARK: - Lyfe cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = event?.shortTitle
        view.backgroundColor = .systemGray
        setupContent()
        setupConstraint()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        imageView.downloadImage(from: urlImage ?? "", activityIndicator: activityIndicator)
    }
    
    //MARK: - Private Methods
    private func setupContent() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date(timeIntervalSince1970: TimeInterval(event?.dates.first?.start ?? 0))
        let endDateString = dateFormatter.string(from: date)
        imageView.contentMode = .scaleAspectFit
        eventTitle.text = event?.title
        eventTitle.numberOfLines = 2
        eventTitle.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .bold)
        eventTitle.text = event?.title
        eventDate.text = endDateString
        eventDescription.text = event?.description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        eventDescription.numberOfLines = 0
    }
}

//MARK: - Setup Constrains
extension EventDetailsViewController {
    private func setupConstraint() {
        let stakView = UIStackView(arrangedSubviews: [eventTitle, eventDate, eventDescription])
        stakView.axis = .vertical
        stakView.alignment = .top
        stakView.distribution = .fill
        stakView.spacing = 10
        setupSubviews(imageView, stakView, activityIndicator)
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(300)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerXWithinMargins.equalToSuperview()
            make.top.equalToSuperview().offset(250)
        }
        stakView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach {
            view.addSubview($0)
        }
    }
}
