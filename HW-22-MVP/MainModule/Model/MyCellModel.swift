//
//  MyCellModel.swift
//  HW-22-MVP
//
//  Created by Олег Ковалев on 17.12.2023.
//

import Foundation

protocol MyCellModelProtocol {
    var filmId: Int? { get }
    var nameRu: String? { get }
    var posterURL: String? { get }
}

struct MyCellModel: MyCellModelProtocol {
    let filmId: Int?
    let nameRu: String?
    let posterURL: String?
}
