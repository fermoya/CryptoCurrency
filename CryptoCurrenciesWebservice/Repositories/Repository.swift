//
//  Repository.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift

protocol Repository {
	associatedtype WebServiceEndpoint: EndpointSet
	associatedtype WebServiceResponseType
	
	func fetch<WebServiceResponseType: Decodable>(type: WebServiceResponseType.Type, from endpoint: WebServiceEndpoint) -> Observable<WebServiceResponseType>
}

public class StocksRepository: WebService, Repository {
	
	typealias WebServiceEndpoint = Endpoints.Stocks
	typealias WebServiceResponseType = StocksResponseType
	
	public func fetch<WebServiceResponseType>(type: WebServiceResponseType.Type, from endpoint: Endpoints.Stocks) -> Observable<WebServiceResponseType> where WebServiceResponseType : Decodable {
		return fetch(type: type, from: endpoint.request)
	}
}

public class CryptoCurrenciesRepository: WebService, Repository {
	
	typealias WebServiceEndpoint = Endpoints.CryptoCurrencies
	typealias WebServiceResponseType = VirtualCoinResponseType
	
	public func fetch<WebServiceResponseType>(type: WebServiceResponseType.Type, from endpoint: Endpoints.CryptoCurrencies) -> Observable<WebServiceResponseType> where WebServiceResponseType : Decodable {
		return fetch(type: type, from: endpoint.request)
	}
}

public class CurrencyConverterRepository: WebService, Repository {
	
	typealias WebServiceEndpoint = Endpoints.CurrencyConverter
	typealias WebServiceResponseType = CurrencyConverterResponseType
	
	public func fetch<WebServiceResponseType>(type: WebServiceResponseType.Type, from endpoint: Endpoints.CurrencyConverter) -> Observable<WebServiceResponseType> where WebServiceResponseType : Decodable {
		return fetch(type: type, from: endpoint.request)
	}
}
