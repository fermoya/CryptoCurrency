//
//  MarketCollectionViewCell.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import CryptoCurrencyData

class MarketCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var percentageLabel: UILabel!

	func bind(to market: StockMarket) {
		nameLabel.text = market.name
		if market.incrementPercentage > 0 {
			percentageLabel.text = "+\(market.incrementPercentage)%"
			percentageLabel.textColor = UIColor.greenPostive
		} else if market.incrementPercentage < 0 {
			percentageLabel.text = "-\(market.incrementPercentage)%"
			percentageLabel.textColor = UIColor.redNegative
		} else {
			percentageLabel.text = "\(market.incrementPercentage)%"
			percentageLabel.textColor = UIColor.grayNeutral
		}
	}
	
}
