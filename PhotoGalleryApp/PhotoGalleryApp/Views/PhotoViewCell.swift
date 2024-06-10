//
//  PhotoViewCell.swift
//  PhotoGalleryApp
//
//  Created by Matvei Khlestov on 10.06.2024.
//

import UIKit

final class PhotoViewCell: UICollectionViewCell, CellProtocol {
    static var reuseId = "PhotoViewCell"
    
    // MARK: - UI Elements
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let checkmark: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with photo: UnsplashPhoto) {
        guard let urlString = photo.urls["regular"], let url = URL(string: urlString) else { return }
        NetworkDataFetcher.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                self.photoImageView.image = UIImage(data: imageData)
            case .failure(let error):
                print("Error fetching image: \(error)")
            }
        }
    }
}

// MARK: - Private methods
private extension PhotoViewCell {
    func setupView() {
        addSubviews()
        
        setConstraints()
        
        updateSelectedState()
    }
    
    func addSubviews() {
        addSubview(photoImageView)
        
        photoImageView.addSubview(checkmark)
    }
    
    func updateSelectedState() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
}

// MARK: - Constraints
private extension PhotoViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -10),
            checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -10)
        ])
    }
}
