//
//  Array+AnyVirtualGood.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/4/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

extension Array where Element == VirtualGood {
	
	func box() -> [AnyVirtualGood] {
		var results = [AnyVirtualGood]()
		forEach { results.append(AnyVirtualGood(virtualGood: $0)) }
		return results
	}
	
}
