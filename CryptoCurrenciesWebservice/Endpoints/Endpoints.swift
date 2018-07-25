//
//  Endpoint.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/19/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

protocol EndpointSet {
	var baseUrl: String { get }
	var request: String { get }
	var queryParams: String { get }
	var path: String { get }
}

public struct Endpoints { }
