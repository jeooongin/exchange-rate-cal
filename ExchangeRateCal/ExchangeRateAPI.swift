//
//  ExchangeRateAPI.swift
//  ExchangeRateCal
//
//  Created by jeongin on 2022/12/13.
//

import Foundation

enum APIError: Error {
    case badURL
    case badStatusCode
}

struct ExchangeRateAPI {
    
    static func fetchJson() async throws -> ExchangeRateModel {
        let urlString = "https://open.er-api.com/v6/latest/KRW"
        guard let url = URL(string: urlString) else {
            throw APIError.badURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw APIError.badStatusCode
            }
            
//            print("data: ", data)
            
            let exchangeRateModel = try JSONDecoder().decode(ExchangeRateModel.self, from: data)
            
//            print("exchangeRateModel: ", exchangeRateModel)
            
            return exchangeRateModel
        } catch {
            throw error
        }
    }
    
}
