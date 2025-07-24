//
//  CurrenciesConversionInteractor.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 18/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import Foundation

// MARK: - Interacting
protocol CurrenciesConversionInteracting {
    var delegate: CurrenciesConversionInteractorDelegate? { get set }
    func fetchQuotes()
}

// MARK: - Delegate
protocol CurrenciesConversionInteractorDelegate: AnyObject {
    func quotesFetched(with quotes: CurrenciesConversion)
    func handleFailure(with serviceError: ServiceError)
}

// MARK: - Main
final class CurrenciesConversionInteractor: CurrenciesConversionInteracting {
    
    weak var delegate: CurrenciesConversionInteractorDelegate?
    
    func fetchQuotes() {
        let serviceUrl = AppEnvironment.domain.value + AppEnvironment.quotes.value
        let parameters = ["access_key": "33c0ee51ffd7880ce2b4d1f9e36799ea"]
        
        ServiceRequest.shared.request(
            method: .get,
            url: serviceUrl,
            parameters: parameters,
            encoding: .default,
            success: { [weak self] result in
                
                self?.handleSuccess(result)
            },
            failure: { [weak self] serviceError in
                self?.delegate?.handleFailure(with: serviceError)
            }
        )
    }
    
    private func handleSuccess(_ data: Data) {
        do {
            let quotes = try JSONDecoder().decode(CurrenciesConversion.self, from: data)
            delegate?.quotesFetched(with: quotes)
        } catch {
            delegate?.handleFailure(with: ServiceError(type: .notMapped))
        }
    }
}
