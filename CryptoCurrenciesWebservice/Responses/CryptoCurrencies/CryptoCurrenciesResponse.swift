//
//  CryptoCurrenciesResponse.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/15/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import CryptoCurrencyData

public struct CryptoCurrenciesResponse {
	
	public var baseUrlString: String
	public var isOk: Bool
	public var message: String
	public var contents: [String: VirtualCoin]!
	
}

extension CryptoCurrenciesResponse: VirtualCoinResponseType { }

extension CryptoCurrenciesResponse: Decodable {
	
	private enum CodingKeys: String, CodingKey {
		case baseUrl = "BaseLinkUrl"
		case message = "Message"
		case response = "Response"
		case contents = "Data"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try! decoder.container(keyedBy: CodingKeys.self)
		
		let response = try! container.decode(String.self, forKey: .response)
		isOk = response == "Success"
		
		baseUrlString = try! container.decode(String.self, forKey: .baseUrl)
		message = try! container.decode(String.self, forKey: .message)
		contents = try? container.decode([String: VirtualCoin].self, forKey: .contents)
	}
	
}
