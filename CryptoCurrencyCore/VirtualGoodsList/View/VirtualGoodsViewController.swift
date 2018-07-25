//
//  VirtualGoodsViewController.swift
//  CryptoCurrencyCore
//
//  Created by Fernando Moya de Rivas on 7/2/18.
//  Copyright © 2018 Fernando Moya de Rivas. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import CryptoCurrencyData

class VirtualGoodsViewController: UIViewController, Bindable {
	typealias ViewModel = VirtualGoodsViewModel
	
	weak var tableView: UITableView!
	private(set) open var viewModel: VirtualGoodsViewModel
	private(set) open var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableVirtualCoinSection<AnyVirtualGood>>!
	
	private let globalQueue = SerialDispatchQueueScheduler(qos: .userInteractive)
	
	init(viewModel: VirtualGoodsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
	}
	
	private func createTableView() -> UITableView {
		let tableView = UITableView()
		tableView.showsVerticalScrollIndicator = false
		tableView.showsHorizontalScrollIndicator = false
		tableView.separatorStyle = .none
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(tableView)

		let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
		let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		let leading = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
		let trailing = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
		
		view.addConstraints([top, bottom, leading, trailing])
		return tableView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView = createTableView()

		setUpView()
		bindViewModel()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setUpView() {
		tableView.register(UINib(nibName: "VirtualGoodTableViewCell", bundle: Bundle(for: VirtualGoodTableViewCell.self)), forCellReuseIdentifier: "VirtualGoodTableViewCell")
		dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableVirtualCoinSection>(configureCell: { (dataSource, tableView, indexPath, virtualGood) -> UITableViewCell in
			let cell = tableView.dequeueReusableCell(withIdentifier: "VirtualGoodTableViewCell", for: indexPath) as! VirtualGoodTableViewCell
			cell.bindTo(virtualGood: virtualGood, price: self.viewModel.price(of: virtualGood.symbol))
			return cell
		})
	}
	
	func bindViewModel() {
		viewModel.sectionedItems
			.observeOn(globalQueue)
			.asDriver(onErrorJustReturn: [])
			.drive(tableView.rx.items(dataSource: dataSource))
			.disposed(by: rx.disposeBag)
		
		tableView.rx.itemSelected
			.map { [unowned self] indexPath -> AnyVirtualGood in
				return try! self.dataSource.model(at: indexPath) as! AnyVirtualGood
			}.subscribe(viewModel.onTap.inputs)
			.disposed(by: rx.disposeBag)
	}
}
