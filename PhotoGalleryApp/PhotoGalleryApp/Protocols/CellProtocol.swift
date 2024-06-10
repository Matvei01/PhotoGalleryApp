//
//  CellProtocol.swift
//  PhotoGalleryApp
//
//  Created by Matvei Khlestov on 10.06.2024.
//

protocol CellProtocol: AnyObject {
    static var reuseId: String { get }
    func configure(with item: UnsplashPhoto)
}
