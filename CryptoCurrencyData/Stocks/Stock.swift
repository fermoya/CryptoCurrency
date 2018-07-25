//
//  Stock.swift
//  CryptoCurrencyData
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct Stock: Equatable {
	public var id: Int
	public var name: String
	public var symbol: String
	
	public static func == (lhs: Stock, rhs: Stock) -> Bool {
		return lhs.id == rhs.id
	}
}

extension Stock: Decodable {
	private enum CodingKeys: String, CodingKey {
		case id = "iexId"
		case name, symbol
	}
	
	public init(from decoder: Decoder) throws {
		let container = try! decoder.container(keyedBy: CodingKeys.self)
		
		let idString = try? container.decode(String.self, forKey: .id)
		if let idString = idString {
			id = Int(idString)!
		} else {
			id = try! container.decode(Int.self, forKey: .id)
		}
		
		name = try! container.decode(String.self, forKey: .name)
		symbol = try! container.decode(String.self, forKey: .symbol)
	}
}
