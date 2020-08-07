//
//  CurrenciesConversionInteractor.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 18/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import Foundation

// MARK: - CurrenciesConversionInteractorDelegate
protocol CurrenciesConversionInteractorDelegate: class {
    func quotesFetched(with quotes: CurrenciesConversion)
    func handleFailure(with serviceError: ServiceError)
}

// MARK: - Main
class CurrenciesConversionInteractor {
    weak var delegate: CurrenciesConversionInteractorDelegate?
    
    func fetchQuotes() {
        
        let serviceUrl = AppEnvironment.domain.value + AppEnvironment.quotes.value
        
        let parameters = [
            "access_key": "33c0ee51ffd7880ce2b4d1f9e36799ea"
            ] as [String: Any]
        
        ServiceRequest.shared.request(method: .get, url: serviceUrl, parameters: parameters, encoding: .default, success: { result in
            do {
                let quotes = try JSONDecoder().decode(CurrenciesConversion.self, from: result)
                self.delegate?.quotesFetched(with: quotes)
            } catch {
                self.delegate?.handleFailure(with: .init(type: .notMapped))
            }
        }, failure: { serviceError  in
            self.delegate?.handleFailure(with: serviceError)
        })
    }
}
