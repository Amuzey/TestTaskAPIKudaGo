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
    
    //MARK: - Public properties
    let imageView = UIImageView()
    let label = UILabel()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configure(with event: Event) {
        imageView.image = UIImage(named: "1")
        label.text = event.shortTitle
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .white
        loadImage(event: event)
    }
    
    //MARK: - Private Methods
    private func loadImage(event: Event) {
        guard let urlString = event.images.first?.image else { return }
        if urlString != "https://kudago.com/media/images/event/82/bb/82bb410cca413007c5598f40c6ebd68c.jpg" {
            networkService.fetchImage(urlString: urlString) { result in
                switch result {
                case .success(let image):
                    self.imageView.image = UIImage(data: image)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
