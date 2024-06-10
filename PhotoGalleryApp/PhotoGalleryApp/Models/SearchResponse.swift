//
//  SearchResponse.swift
//  PhotoGalleryApp
//
//  Created by Matvei Khlestov on 10.06.2024.
//

struct SearchResponse: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: [PhotoSize.RawValue: String]
}

enum PhotoSize: String {
    case raw
    case full
    case regular
    case small
    case thumb
}
