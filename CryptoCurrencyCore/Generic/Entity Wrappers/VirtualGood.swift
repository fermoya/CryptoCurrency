//
//  VirtualGood.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/2/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import CryptoCurrencyData

enum VirtualGoodType {
	case virtualCoin
	case stock
}

enum VirtualGoodSearchType {
	case virtualCoin
	case stock
}

protocol VirtualGood {
	var id: Int { get }
	var name: String { get }
	var fullName: String { get }
	var symbol: String { get }
	var imageUrlString: String? { get }
}

struct AnyVirtualGood: VirtualGood, IdentifiableType, Equatable {
	private(set) var virtualGood: VirtualGood

	var id: Int { return virtualGood.id }
	var name: String { return virtualGood.name }
	var fullName: String { return virtualGood.fullName }
	var symbol: String { return virtualGood.symbol }
	var imageUrlString: String? { return virtualGood.imageUrlString }
	
	typealias Identity = Int
	var identity: Int { return id }
	
	static func == (lhs: AnyVirtualGood, rhs: AnyVirtualGood) -> Bool {
		return lhs.id == rhs.id
	}
	
	init(virtualGood: VirtualGood) {
		self.virtualGood = virtualGood
	}
}

extension VirtualCoin: VirtualGood {  }

extension VirtualCoin: IdentifiableType {
 	public var identity: Int { return id }
}

extension Stock: VirtualGood {
	var imageUrlString: String? {
		return "https://storage.googleapis.com/iex/api/logos/\(symbol).png"
	}
	var fullName: String { return name }
}

extension Stock: IdentifiableType {
	public typealias Identity = Int
	public var identity: Int { return id }
}
