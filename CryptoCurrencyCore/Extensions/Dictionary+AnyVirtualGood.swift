//
//  Collection+AnyVirtualGood.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/4/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

extension Dictionary where Value == AnyVirtualGood {
	
	init(virtualGoods: [Key: VirtualGood]) {
		var result = [Key: AnyVirtualGood]()
		virtualGoods.forEach { result[$0] = AnyVirtualGood(virtualGood: $1) }
		self.init()
		self = result
	}
	
	func unBox() -> [Key: VirtualGood] {
		var result = [Key: VirtualGood]()
		forEach { result[$0] = $1.virtualGood }
		return result
	}
	
}

extension Dictionary where Value: VirtualGood {
	
	func box() -> [Key: AnyVirtualGood] {
		var result = [Key: AnyVirtualGood]()
		forEach { result[$0] = AnyVirtualGood(virtualGood: $1) }
		return result
	}
}
