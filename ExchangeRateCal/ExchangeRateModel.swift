//
//  Model.swift
//  ExchangeRateCal
//
//  Created by jeongin on 2022/12/13.
//

import Foundation

struct ExchangeRateModel: Codable {
    let rates: [String: Double]?
}
