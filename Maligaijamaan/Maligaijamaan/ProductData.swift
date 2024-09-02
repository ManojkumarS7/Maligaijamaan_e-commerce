//
//  ProductData.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import Foundation

struct Product: Codable {
    let id: String
    let categoryId: String
    let name: String
    var price: Double
    let image: String
    var quantity: String
    let quantityType: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryId = "category_id "
        case name
        case price
        case image = "image_path"
        case quantity
        case quantityType = "quantity_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        categoryId = try container.decode(String.self, forKey: .categoryId)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decode(String.self, forKey: .image)
        quantity = try container.decode(String.self, forKey: .quantity)
        quantityType = try container.decode(String.self, forKey: .quantityType)

        // Decode price as either Double or String
        if let priceString = try? container.decode(String.self, forKey: .price), let priceDouble = Double(priceString) {
            price = priceDouble
        } else {
            price = try container.decode(Double.self, forKey: .price)
        }
    }
}
