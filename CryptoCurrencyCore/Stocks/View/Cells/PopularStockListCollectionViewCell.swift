//
//  PopularStockListCollectionViewCell.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/27/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import ChameleonFramework
import CryptoCurrencyData

class PopularStockListCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var thumbnailImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	
	func bind(to market: PopularMarket) {
		titleLabel.text = market.name
		thumbnailImageView.image = UIImage(named: market.imageName, in: Bundle(for: type(of: self)), compatibleWith: nil)
		containerView.layer.masksToBounds = false
		containerView.layer.cornerRadius = 8
		containerView.layer.borderWidth = 3
		
		let color = UIColor(hexString: market.colorHex)
		containerView.layer.borderColor = color?.cgColor
		titleLabel.textColor = color
		
		containerView.backgroundColor = color?.withAlphaComponent(0.05)
	}

}
