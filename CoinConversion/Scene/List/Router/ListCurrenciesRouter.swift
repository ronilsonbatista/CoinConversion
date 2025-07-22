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
    
//    func createListCurrenciesScreen(conversion: Conversion) {
//        let viewController = ListCurrenciesViewController(
//            presenter: ListCurrenciesPresenter(
//                interactor: ListCurrenciesInteractor(),
//                conversion: conversion,
//                dataManager: DataManager(),
//                router: self
//        ))
//        
//        if let topViewController = UIApplication.shared.topMostViewController() {
//            topViewController.navigationController?.pushViewController(
//                viewController, animated: true
//            )
//        }
//    }

    func dismissToConversion(code: String, name: String, conversion: Conversion) {
        delegate?.currencyFetched(code: code, name: name, conversion: conversion)

        DispatchQueue.main.async {
            if let topVC = UIApplication.shared.topMostViewController() {
                topVC.navigationController?.popViewController(animated: true)
            }
        }
    }
}
