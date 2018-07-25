//
//  StockMarket.swift
//  CryptoCurrencyData
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct StockMarket: Decodable, Equatable {
	public var name: String
	public var incrementPercentage: Float
	
	private enum CodingKeys: String, CodingKey {
		case name = "venueName"
		case incrementPercentage = "marketPercent"
	}
	
	public static func == (lhs: StockMarket, rhs: StockMarket) -> Bool { return lhs.name == rhs.name }
}

