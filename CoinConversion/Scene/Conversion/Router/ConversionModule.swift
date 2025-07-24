//
//  ConversionModule.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 24/07/25.
//  Copyright © 2025 Ronilson Batista. All rights reserved.
//

import UIKit

// MARK: - Module
struct ConversionModule {
    static func build(window: UIWindow, delegate: ConversionRouterDelegate?) {
        let router = ConversionRouter()
        router.delegate = delegate
        router.setInitialScreen(in: window)
    }
}
