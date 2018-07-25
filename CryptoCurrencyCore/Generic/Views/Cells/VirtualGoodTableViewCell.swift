//
//  VirtualGoodTableViewCell.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 6/18/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import CryptoCurrenciesWebservice
import CryptoCurrencyData
import Kingfisher

class VirtualGoodTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var iconImageView: UIImageView!
	
	func bindTo(virtualGood: AnyVirtualGood, price: Observable<String>? = nil) {
		nameLabel.text = virtualGood.name
		
		if let price = price {
			price.asDriver(onErrorJustReturn: "")
				.drive(priceLabel.rx.text)
				.disposed(by: rx.disposeBag)
		} else {
			priceLabel.text = ""
		}
		
		if let imageUrlString = virtualGood.imageUrlString, let imageUrl = URL(string: imageUrlString) {
			self.iconImageView.kf.setImage(with: imageUrl)
		}
	}
	
}
