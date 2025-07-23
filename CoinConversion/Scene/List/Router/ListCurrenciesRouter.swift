//
//  ListCurrenciesRouter.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 21/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import Foundation

// MARK: - Router Protocol
protocol ListCurrenciesRouting: AnyObject {
    func dismissToConversion(code: String, name: String, conversion: Conversion)
}

protocol ListCurrenciesRouterDelegate: AnyObject {
    func currencyFetched(code: String, name: String, conversion: Conversion)
}

// MARK: - Main
final class ListCurrenciesRouter: ListCurrenciesRouting {
    weak var delegate: ListCurrenciesRouterDelegate?
    
    init(delegate: ListCurrenciesRouterDelegate?) {
        self.delegate = delegate
    }
    
    func dismissToConversion(code: String, name: String, conversion: Conversion) {
        delegate?.currencyFetched(code: code, name: name, conversion: conversion)
        
        DispatchQueue.main.async {
            if let topVC = UIApplication.shared.topMostViewController() {
                topVC.navigationController?.popViewController(animated: true)
            }
        }
    }
}
