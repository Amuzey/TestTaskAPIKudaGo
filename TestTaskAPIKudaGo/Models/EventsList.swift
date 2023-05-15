//
//  Event.swift
//  TestTaskAPIKudaGo
//
//  Created by Алексей on 13.05.2023.
//

import Foundation

// MARK: - EventsList
struct EventsList: Codable {
    let results: [Event]
}

// MARK: - Event
struct Event: Codable {
    let dates: [DateElement]
    let title, description: String
    let images: [Image]
    let shortTitle: String
    
    enum CodingKeys: String, CodingKey {
        case dates, title, description, images
        case shortTitle = "short_title"
    }
}

// MARK: - DateElement
struct DateElement: Codable {
    let start, end: Int
}

// MARK: - Image
struct Image: Codable {
    let image: String
}
