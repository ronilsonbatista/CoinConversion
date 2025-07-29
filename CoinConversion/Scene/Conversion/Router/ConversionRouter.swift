//
//  ConversionRouter.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 18/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import UIKit

// MARK: - Routing
protocol ConversionRouting: AnyObject {
    var delegate: ConversionRouterDelegate? { get set }
    func navigateToListCurrencies(using conversion: Conversion)
}

// MARK: - Delegate
protocol ConversionRouterDelegate: AnyObject {
    func currencyFetched(_ code: String, _ name: String, _ conversion: Conversion)
}

// MARK: - Main
final class ConversionRouter: ConversionRouting {
    
    weak var delegate: ConversionRouterDelegate?
    
    func setInitialScreen(in window: UIWindow) {
        let interactor = CurrenciesConversionInteractor()
        let dataManager = DataManager()
        let presenter = ConversionPresenter(interactor: interactor, dataManager: dataManager, router: self)
        let viewController = ConversionViewController(presenter: presenter)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func navigateToListCurrencies(using conversion: Conversion) {
        let listVC = ListCurrenciesModule.build(conversion: conversion, delegate: self)
        
        if let topVC = UIApplication.shared.topMostViewController() {
            topVC.navigationController?.pushViewController(listVC, animated: true)
        }
    }
}

// MARK: - ListCurrenciesRouterDelegate
extension ConversionRouter: ListCurrenciesRouterDelegate {
    func currencyFetched(code: String, name: String, conversion: Conversion) {
        delegate?.currencyFetched(code, name, conversion)
    }
}
