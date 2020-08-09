//
//  ListCurrenciesInteractor.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 18/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import Foundation


// MARK: - ListCurrenciesInteractorDelegate
protocol ListCurrenciesInteractorDelegate: class {
    func currenciesFetched(with listCurrencies: ListCurrencies)
    func handleFailure(with serviceError: ServiceError)
}

// MARK: - Main
class ListCurrenciesInteractor {
    weak var delegate: ListCurrenciesInteractorDelegate?
    
    func fetchListCurrencies() {
        
        let serviceUrl = AppEnvironment.domain.value + AppEnvironment.listCurrencies.value
        
        let parameters = ["access_key": "33c0ee51ffd7880ce2b4d1f9e36799ea"] as [String: Any]
        
        ServiceRequest.shared.request(method: .get, url: serviceUrl, parameters: parameters, encoding: .default, success: { result in
            do {
               let list = try JSONDecoder().decode(ListCurrencies.self, from: result)
               self.delegate?.currenciesFetched(with: list)
            } catch {
               self.delegate?.handleFailure(with: .init(type: .notMapped))
            }
        }, failure: { serviceError  in
           self.delegate?.handleFailure(with: serviceError)
        })
    }
}
