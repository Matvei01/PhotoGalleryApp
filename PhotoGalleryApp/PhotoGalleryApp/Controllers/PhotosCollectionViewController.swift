//
//  PhotosCollectionViewController.swift
//  PhotoGalleryApp
//
//  Created by Matvei Khlestov on 09.06.2024.
//

import UIKit

final class PhotosCollectionViewController: UICollectionViewController {
    
    // MARK: -  Private Properties
    private let reuseIdentifier = "CellId"
    
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
    
    // MARK: -  Private Methods
    private func setupCollectionView() {
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: reuseIdentifier
        )
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
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = .systemRed
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
}

// MARK: - UISearchResultsUpdating
extension PhotosCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
