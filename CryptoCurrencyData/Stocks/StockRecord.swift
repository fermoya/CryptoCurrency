//
//  StockRecord.swift
//  CryptoCurrencyData
//
//  Created by Fernando Moya de Rivas on 7/11/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct StockRecord {
	
	public var date: String
	public var price: Float
	public var highestPrice: Float
	public var lowestPrice: Float
	public var firstPrice: Float
	public var lastPrice: Float
	
	private var highestPriceOptional: Float?
	private var lowestPriceOptional: Float?
	private var firstPriceOptional: Float?
	private var lastPriceOptional: Float?
}

extension StockRecord: Decodable {
	
	private enum CodingKeys: String, CodingKey {
		case date
		case lastPrice = "close"
		case highestPrice = "high"
		case lowestPrice = "low"
		case firstPrice = "open"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try! decoder.container(keyedBy: CodingKeys.self)
		
		date = try! container.decode(String.self, forKey: .date)
		
		lastPriceOptional = try? container.decode(Float.self, forKey: .lastPrice)
		highestPriceOptional = try? container.decode(Float.self, forKey: .highestPrice)
		lowestPriceOptional = try? container.decode(Float.self, forKey: .lowestPrice)
		firstPriceOptional = try? container.decode(Float.self, forKey: .firstPrice)
		
		lastPrice = lastPriceOptional ?? 0
		highestPrice = highestPriceOptional ?? 0
		lowestPrice = lowestPriceOptional ?? 0
		firstPrice = firstPriceOptional ?? 0
		
		price = (highestPrice + lowestPrice) / 2
	}
	
}
