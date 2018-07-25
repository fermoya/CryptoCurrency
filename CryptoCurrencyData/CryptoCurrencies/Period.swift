//
//  Period.swift
//  CryptoCurrencyData
//
//  Created by Fernando Moya de Rivas on 6/21/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct Period {
	public var from: Date
	public var to: Date
	
	public init(from: Date, to: Date) {
		self.from = from
		self.to = to
	}
}
