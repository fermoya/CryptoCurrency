//
//  CryptoCurrencyHistorialDataResponse.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/21/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData

public struct CryptoCurrencyHistorialDataResponse {
	public var isOk: Bool
	public var contents: [VirtualCoinRecord]!
	public var period: Period!
}

extension CryptoCurrencyHistorialDataResponse: VirtualCoinResponseType { }

extension CryptoCurrencyHistorialDataResponse: Decodable {
	
	private enum CodingKeys: String, CodingKey {
		case response = "Response"
		case contents = "Data"
		case start = "TimeTo"
		case end = "TimeFrom"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try! decoder.container(keyedBy: CodingKeys.self)
		
		let response = try! container.decode(String.self, forKey: .response)
		isOk = response == "Success"
		
		let startSecondsFrom1970 = try? container.decode(Int64.self, forKey: .start)
		
		var start: Date? = nil
		var end: Date? = nil
		
		if let startSecondsFrom1970 = startSecondsFrom1970 {
			start = Date(timeIntervalSince1970: TimeInterval(startSecondsFrom1970))
		}
		
		let endSecondsFrom1970 = try? container.decode(Int64.self, forKey: .end)
		if let endSecondsFrom1970 = endSecondsFrom1970 {
			end = Date(timeIntervalSince1970: TimeInterval(endSecondsFrom1970))
		}
		
		if let start = start, let end = end {
			period = Period(from: start, to: end)
		}
		
		contents = try? container.decode([VirtualCoinRecord].self, forKey: .contents)
	}
	
}
