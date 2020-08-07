//
//  ConversionModel.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 22/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import Foundation

// MARK: - ConversionViewModel
class ConversionViewModel: NSObject {
    var date: Double?
    var conversion: [ConversionCurrenciesViewModel]?
    
    init(date: Double, conversion: [ConversionCurrenciesViewModel]) {
        self.date = date
        self.conversion = conversion
    }
}

// MARK: - ConversionCurrenciesViewModel
class ConversionCurrenciesViewModel: NSObject {
    var code: String?
    var quotes: Double?
    
    init(code: String, quotes: Double) {
        self.code = code
        self.quotes = quotes
    }
}
