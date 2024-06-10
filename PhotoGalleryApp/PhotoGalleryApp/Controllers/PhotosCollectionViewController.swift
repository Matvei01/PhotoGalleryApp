//
//  PhotosCollectionViewController.swift
//  PhotoGalleryApp
//
//  Created by Matvei Khlestov on 09.06.2024.
//

import UIKit

final class PhotosCollectionViewController: UICollectionViewController {
    
    // MARK: -  Private Properties
    private let networkDataFetcher = NetworkDataFetcher.shared
    
    private var photos: [UnsplashPhoto] = []
    
    private var searchTimer: Timer?
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInserts = UIEdgeInsets(
        top: 20,
        left: 20,
        bottom: 20,
        right: 20
    )
    
    // MARK: -  UI Elements
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            systemItem: .action,
            primaryAction: barButtonItemTapped
        )
        button.tag = 0
        return button
    }()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            systemItem: .add,
            primaryAction: barButtonItemTapped
        )
        button.tag = 1
        return button
    }()
    
    // MARK: -  Action
    private lazy var barButtonItemTapped = UIAction { [unowned self] action in
        guard let sender = action.sender as? UIBarButtonItem else { return }
        
        switch sender.tag {
        case 0:
            actionBarButtonItemTapped()
        default:
            addBarButtonItemTapped()
        }
    }
    
    // MARK: -  Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        setupCollectionView()
        
        setupNavigationBar()
        
        setupSearchBar()
    }
}

// MARK: -  Private Methods
extension PhotosCollectionViewController {
    private func setupCollectionView() {
        collectionView.register(
            PhotoViewCell.self,
            forCellWithReuseIdentifier: PhotoViewCell.reuseId
        )
        
        collectionView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        
        collectionView.contentInsetAdjustmentBehavior = .automatic
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            actionBarButtonItem,
            addBarButtonItem
        ]
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func addBarButtonItemTapped() {
        print("Add")
    }
    
    private func actionBarButtonItemTapped() {
        print("Action")
    }
    
    private func fetchPhotos(searchTerm: String) {
        networkDataFetcher.fetchData(SearchResponse.self, 
                                     searchTerm: searchTerm) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.photos = response.results
                self.collectionView.reloadData()
            case .failure(let error):
                print("Error fetching photos: \(error)")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = photos[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.reuseId, for: indexPath)
        guard let cell = cell as? PhotoViewCell else { return UICollectionViewCell() }
        cell.configure(with: photo)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosCollectionViewController {
    
}

// MARK: - UICollectionViewDelegate
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        sectionInserts.left
    }
}

// MARK: - UISearchResultsUpdating
extension PhotosCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text, !searchTerm.isEmpty else { return }
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.fetchPhotos(searchTerm: searchTerm)
        })
    }
}
