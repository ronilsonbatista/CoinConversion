//
//  ListCurrenciesModel.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 20/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import Foundation

// MARK: - ListCurrenciesModel
struct ListCurrenciesModel {
    let name: String
    let code: String
}

// MARK: - SortType
enum SortType {
    case name
    case code
}
