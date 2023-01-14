//
//  CurrencyController.swift
//  CurrencyRates
//
//  Created by Quien on 2023/1/13.
//

import Foundation

class CurrencyController {
  static let shared = CurrencyController()
  let baseURL = URL(string: "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/")
  let pathComponent = "currencies"
  let pathExtension = "json"
  
  func fetchCurrencies() async throws -> [String: String] {
    let currenciesURL = baseURL?.appendingPathComponent(pathComponent).appendingPathExtension(pathExtension)
    let (data, response) = try await URLSession.shared.data(from: currenciesURL!)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw CurrencyControllerError.currencyListNotFound
    }
    
    let decoder = JSONDecoder()
    let currencyListResponse = try decoder.decode(CurrencyListResponse.self, from: data)
    return currencyListResponse
  }
  
  func fetchCurrencyRatesBaseOnCAD() async throws -> [String: Double] {
    let currenciesURL = baseURL?.appendingPathComponent(pathComponent).appendingPathComponent("cad").appendingPathExtension(pathExtension)
    let (data, response) = try await URLSession.shared.data(from: currenciesURL!)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw CurrencyControllerError.currencyRateListNotFound
    }
    
    let decoder = JSONDecoder()
    let currencyRate = try decoder.decode(CurrencyRatesBaseOnCADResponse.self, from: data)
    return currencyRate.currencies
  }
  
  func fetchCurrencyRateBaseOnCAD(forCurrency currencyName: String) async throws -> Double {
    let currenciesURL = baseURL?.appendingPathComponent(pathComponent).appendingPathComponent(currencyName).appendingPathComponent("cad").appendingPathExtension(pathExtension)
    let (data, response) = try await URLSession.shared.data(from: currenciesURL!)

    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw CurrencyControllerError.currencyConvertRequestFailed
    }
    
    let decoder = JSONDecoder()
    let currencyRate = try decoder.decode(CurrencyRateBaseOnCADResponse.self, from: data)
    return currencyRate.currency
  }
  
}

enum CurrencyControllerError: Error, LocalizedError {
  case currencyListNotFound
  case currencyRateListNotFound
  case currencyConvertRequestFailed
}
