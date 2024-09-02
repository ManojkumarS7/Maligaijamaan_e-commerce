//
//  CartData.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import Foundation


struct CartData: Decodable {
    let id: String
    let user_id: String
    let name: String
    let phone: String
    let product_id: String
    let product_price: String
    let product_name: String
    let status: String
    let date_created: String
    let img_path : String

    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case name
        case phone
        case product_id = "product_id"
        case product_price
        case product_name = "Product_name"
        case status
        case date_created
        case img_path = "img_path"
    }
}
