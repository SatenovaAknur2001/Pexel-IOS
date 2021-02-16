//
//  Photo Structs.swift
//  Pexels
//
//  Created by Kenes Yerassyl on 8/15/20.
//  Copyright © 2020 Tinker Tech. All rights reserved.
//

import Foundation

struct Src: Decodable {
    var original: String
    var large: String
    
    enum CodingKeys: String, CodingKey {
        case original
        case large
    }
}

struct Photo: Decodable {
    var id: Int
    var width: Float
    var height: Float
    var photographer: String
    var photographerID: Int
    var src: Src
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case photographer
        case photographerID = "photographer_id"
        case src
        case url
    }
}

struct SearchResult: Decodable {
    let totalResults: Int
    let page: Int
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case page
        case photos
    }
}

struct CuratedPhotos: Decodable {
    let photos: [Photo]
    
    enum CodingKeys: CodingKey {
        case photos
    }
}
