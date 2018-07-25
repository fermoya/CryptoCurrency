//
//  VirtualCoinRecord.swift
//  CryptoCurrencyData
//
//  Created by Fernando Moya de Rivas on 6/21/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct VirtualCoinRecord {
	
	public var date: Int64
	public var price: Float
	public var highestPrice: Float
	public var lowestPrice: Float
	public var firstPrice: Float
	public var lastPrice: Float
	
}

extension VirtualCoinRecord: Decodable {
	
	private enum CodingKeys: String, CodingKey {
		case date = "time"
		case lastPrice = "close"
		case highestPrice = "high"
		case lowestPrice = "low"
		case firstPrice = "open"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try! decoder.container(keyedBy: CodingKeys.self)
		
		date = try! container.decode(Int64.self, forKey: .date)		
		lastPrice = try! container.decode(Float.self, forKey: .lastPrice)
		highestPrice = try! container.decode(Float.self, forKey: .highestPrice)
		lowestPrice = try! container.decode(Float.self, forKey: .lowestPrice)
		firstPrice = try! container.decode(Float.self, forKey: .firstPrice)
		price = (highestPrice + lowestPrice) / 2
	}
	
}
