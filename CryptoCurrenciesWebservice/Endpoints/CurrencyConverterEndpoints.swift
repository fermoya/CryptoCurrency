//
//  CurrencyConverterEndpoints.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/28/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

extension Endpoints {
	
	public enum CurrencyConverter {
		case list
		case convert(fromSymbol: String, toSymbol: String)
		case last8Days(fromSymbol: String, toSymbol: String)
	}
	
}

extension Endpoints.CurrencyConverter: EndpointSet {
	var baseUrl: String {
		return "https://free.currencyconverterapi.com/api/v5"
	}
	
	var request: String {
		return baseUrl + path + queryParams
	}
	
	var queryParams: String {
		switch self {
		case .list:
			return ""
		case .convert(let fromSymbol, let toSymbol):
			return "?q=\(fromSymbol)_\(toSymbol)&compact=ultra"
		case .last8Days(let fromSymbol, let toSymbol):
			let dateFormatter = DateFormatter()
			dateFormatter.calendar = Calendar(identifier: .gregorian)
			dateFormatter.dateFormat = "yyyy-MM-dd"
			let now = Date()
			let eightDaysAgo = now.addingTimeInterval(TimeInterval(-8 * 24 * 60 * 60))
			return "?q=\(fromSymbol)_\(toSymbol)&compact=ultra&date=\(dateFormatter.string(from: eightDaysAgo))&endDate=\(dateFormatter.string(from: now))"
		}
	}
	
	var path: String {
		switch self {
		case .list:
			return "/currencies"
		case .convert:
			return "/convert"
		case .last8Days:
			return "/convert"
		}
	}
	
	
}
