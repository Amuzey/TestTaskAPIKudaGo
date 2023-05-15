//
//  ViewController.swift
//  TestTaskAPIKudaGo
//
//  Created by Алексей on 13.05.2023.
//

import UIKit

class EventsListViewController: UIViewController {
    //MARK: - Private properties
    private let networkService = NetworkDataFetcher()
    private let layout = UICollectionViewFlowLayout()
    private var isFetching = false
    private var curentPage = 1
    private var events: [Event] = []
    private lazy var eventListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    //MARK: - Life cycles
    override func loadView() {
        view = eventListCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionViewCell()
        getEvents(page: curentPage)
    }
    
    //MARK: - Private methods
    private func setupNavigationBar() {
        navigationItem.title = "Екатеринбург"
        
    }
    
    private func getEvents(page: Int) {
        networkService.getEvents(page: page) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let events):
                self.events += events.results
                self.eventListCollectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupCollectionViewCell() {
        eventListCollectionView.delegate = self
        eventListCollectionView.dataSource = self
        eventListCollectionView.register(EventCell.self, forCellWithReuseIdentifier: "EventCell")
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension EventsListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as? EventCell else { return UICollectionViewCell() }
        let event = events[indexPath.item]
        cell.configure(with: event)
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = events[indexPath.item]
        let eventDetailsVC = EventDetailsViewController()
        eventDetailsVC.event = event
        navigationController?.pushViewController(eventDetailsVC, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension EventsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingWidth = 15 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widhtPerItem = availableWidth / itemsPerRow
        return CGSize(width: widhtPerItem, height: widhtPerItem + widhtPerItem / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

//MARK: - UIScrollViewDelegate
extension EventsListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollEnd(scrollView)
    }
    
    private func handleScrollEnd(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        let buffer: CGFloat = 50

        if offsetY > contentHeight - scrollViewHeight - buffer {
            loadMoreEvents()
        }
    }

    private func loadMoreEvents() {
        guard !isFetching else { return }
        isFetching = true
        networkService.getEvents(page: curentPage + 1) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            switch result {
            case .success(let events):
                self.curentPage += 1
                self.events += events.results
                self.eventListCollectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

