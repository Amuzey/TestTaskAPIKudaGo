//
//  EventCell.swift
//  TestTaskAPIKudaGo
//
//  Created by Алексей on 13.05.2023.
//

import UIKit
import SnapKit

class EventCell: UICollectionViewCell {
    //MARK: - Private properties
    private var networkService = NetworkService()
    private var imageURL: String? {
        didSet {
            imageView.image = nil
            activityIndicator.startAnimating()
            updateImage()
        }
    }
    
    //MARK: - Public properties
    let imageView = UIImageView()
    let label = UILabel()
    let activityIndicator = UIActivityIndicatorView()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(activityIndicator)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-15)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    //MARK: - Methods
    func configure(with event: Event) {
        imageURL = event.images.first?.image
        label.text = event.shortTitle
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
    }
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        imageView.downloadImage(from: imageURL, activityIndicator: activityIndicator)
    }
}

