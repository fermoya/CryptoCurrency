//
//  VirtualCoin.swift
//  CryptoCurrencyData
//
//  Created by Fernando Moya de Rivas on 6/15/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct VirtualCoin: Equatable {
	private var baseUrl = "https://www.cryptocompare.com/"
	
	public var id: Int
	public var name: String
	public var symbol: String
	public var fullName: String
	public var imageUrlString: String?
	public var sortOrder: Int
	
	public var algorithm: String?
	public var totalCoins: Int64?
	public var freeCoins: Int64?
	
	public static func == (lhs: VirtualCoin, rhs: VirtualCoin) -> Bool { return lhs.id == rhs.id }
}

extension VirtualCoin: Decodable {
	
	private enum CodingKeys: String, CodingKey {
		case id = "Id"
		case imageUrlString = "ImageUrl"
		case name = "CoinName"
		case fullName = "FullName"
		case symbol = "Name"
		case sortOrder = "SortOrder"
		case algorithm = "Algorithm"
		case totalCoins = "TotalCoinSupply"
		case freeCoins = "TotalCoinsFreeFloat"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try! decoder.container(keyedBy: CodingKeys.self)
		
		let idString = try! container.decode(String.self, forKey: .id)
		id = Int(idString)!

		let imageRelativeUrlString = try? container.decode(String.self, forKey: .imageUrlString)
		if let imageRelativeUrlString = imageRelativeUrlString {
			imageUrlString = "\(baseUrl)/\(imageRelativeUrlString)"
		}
		
		symbol = try! container.decode(String.self, forKey: .symbol)
		name = try! container.decode(String.self, forKey: .name)
		fullName = try! container.decode(String.self, forKey: .fullName)
		algorithm = try? container.decode(String.self, forKey: .algorithm)
		
		let sortOrderString = try! container.decode(String.self, forKey: .sortOrder)
		sortOrder = Int(sortOrderString)!
		
		let totalCoinsString = try! container.decode(String.self, forKey: .totalCoins)
		totalCoins = Int64(totalCoinsString)
		
		let freeCoinsString = try! container.decode(String.self, forKey: .freeCoins)
		freeCoins = Int64(freeCoinsString)
	}
	
}
