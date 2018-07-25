//
//  PopularMarket.swift
//  CryptoCurrenciesWebservice
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

public struct PopularMarket: Equatable {
	public var name: String
	public var colorHex: String
	public var imageName: String
}

extension PopularMarket {
	
	public static let `default` = [
		PopularMarket(name: "Most active stocks", colorHex: "#F5A623", imageName: "thumbnail-active"),
		PopularMarket(name: "Gaining stocks", colorHex: "#4faf5b", imageName: "thumbnail-increment"),
		PopularMarket(name: "Losing stocks", colorHex: "#FF4337", imageName: "thumbnail-decrement"),
		PopularMarket(name: "Most traded stocks", colorHex: "#494B4D", imageName: "thumbnail-volume"),
		PopularMarket(name: "Most traded stocks (by percentage)", colorHex: "#898C8F", imageName: "thumbnail-percentage")
	]

}
