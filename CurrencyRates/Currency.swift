//
//  Currency.swift
//  CurrencyRates
//
//  Created by Quien on 2023/1/13.
//

import Foundation

typealias CurrencyListResponse = [String: String]

struct CurrencyRatesBaseOnCADResponse: Codable {
  var date: String
  var currencies: [String: Double]
  
  enum CodingKeys: String, CodingKey {
    case date
    case currencies = "cad"
  }
}

struct CurrencyRateBaseOnCADResponse: Codable {
  var date: String
  var currency: Double
  
  enum CodingKeys: String, CodingKey {
    case date
    case currency = "cad"
  }
}
