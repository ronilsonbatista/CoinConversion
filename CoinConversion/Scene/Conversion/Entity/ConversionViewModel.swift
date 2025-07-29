//
//  ConversionModel.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 22/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import Foundation

// MARK: - ConversionViewModel
struct ConversionViewModel {
    let date: Double
    let currencies: [ConversionCurrencyViewModel]
}

// MARK: - ConversionCurrencyViewModel
struct ConversionCurrencyViewModel {
    let code: String
    let quotes: Double
}

// MARK: - Conversion
enum Conversion {
    case to
    case from
}
