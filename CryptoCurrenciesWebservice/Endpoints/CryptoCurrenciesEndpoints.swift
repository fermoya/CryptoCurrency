//
//  CryptoCurrenciesEndpoints.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

extension Endpoints {
	public enum CryptoCurrencies {
		case list
		case price(fromSymbol: String, toSymbols: [String])
		case historicalData(fromSymbol: String, toSymbol: String, limit: Int, aggregate: Int)
	}
}

extension Endpoints.CryptoCurrencies: EndpointSet {
	
	var baseUrl: String { return "" }
	
	var request: String {
		return path + queryParams
	}
	
	var queryParams: String {
		switch self {
		case .list:
			return ""
		case .price(let fromSymbol, let toSymbols):
			return "?" + "fsym=\(fromSymbol)&tsyms=\(toSymbols.joined(separator: ","))"
		case .historicalData(let fromSymbol, let toSymbol, let limit, let aggregate):
			return "?" + "fsym=\(fromSymbol)&tsym=\(toSymbol)&limit=\(limit)&aggregate=\(aggregate)"
		}
	}
	
	var path: String {
		switch self {
		case .list:
			return "https://www.cryptocompare.com/api/data/coinlist"
		case .price:
			return "https://min-api.cryptocompare.com/data/price"
		case .historicalData:
			return "https://min-api.cryptocompare.com/data/histoday"
		}
	}
	
}
