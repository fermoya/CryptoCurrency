//
//  StocksEndpoints.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

extension Endpoints {
	
	public enum Stocks {
		case list
		case mostactive
		case gainers
		case losers
		case stockVolume
		case stockPercent
		case markets
		case logo(String)
		case historicalData(last: String, fromSymbol: String)
	}
	
}

extension Endpoints.Stocks: EndpointSet {
	var baseUrl: String {
		return "https://api.iextrading.com/1.0"
	}
	
	var request: String {
		return baseUrl + path + queryParams
	}
	
	var queryParams: String {
		return ""
	}
	
	var path: String {
		switch self {
		case .list:
			return "/ref-data/symbols"
		case .mostactive:
			return "/stock/market/list/mostactive"
		case .gainers:
			return "/stock/market/list/gainers"
		case .losers:
			return "/stock/market/list/losers"
		case .stockVolume:
			return "/stock/market/list/iexvolume"
		case .stockPercent:
			return "/stock/market/list/iexpercent"
		case .markets:
			return "/market"
		case .historicalData(let period, let symbol):
			return "/stock/\(symbol.lowercased())/chart/\(period)"
		case .logo(let symbol):
			return "/stock/\(symbol.lowercased())/logo"
		}
	}
	
	
}
