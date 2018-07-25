//
//  VirtualGoodsEditableViewController.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/4/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class VirtualGoodsEditableViewController: VirtualGoodsViewController {
	
	private var editableViewModel: VirtualGoodsEditableViewModel
	
	init(viewModel: VirtualGoodsEditableViewModel) {
		self.editableViewModel = viewModel
		super.init(viewModel: viewModel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setUpView() {
		super.setUpView()
		dataSource.titleForHeaderInSection = editableViewModel.titleForHeaderInSection
		dataSource.canEditRowAtIndexPath = editableViewModel.canEditRowAtIndexPath
	}
	
	override func bindViewModel() {
		super.bindViewModel()
		
		tableView.rx.itemDeleted
			.map { [unowned self] indexPath in
				let coin = try! self.dataSource.model(at: indexPath) as! AnyVirtualGood
				return coin.symbol
			}.bind(to: editableViewModel.onRemove.inputs)
			.disposed(by: rx.disposeBag)
		
		
		editableViewModel.isEditing.asObservable().do(onNext: { [unowned self] isEditing in
			self.tableView.setEditing(isEditing, animated: true)
		}).subscribe().disposed(by: rx.disposeBag)
	}
	
}
