//
//  ProductsListTableVC.swift
//  WLAssignment
//
//  Created by Nick Yekimov on 3/24/18.
//  Copyright © 2018 Nick Yekimov. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa

class ProductsListTableVC: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var initialActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var reloadBtn: UIButton!

    // MARK: - Private Properties
    private var viewModel: ProductsListViewModelProtocol = ProductsListViewModel(productsListService: ProductsListService())
    private var dataSource: RxTableViewSectionedReloadDataSource<ProductSection>!
    private let disposeBag = DisposeBag()
    private var initialLoadingDone = false

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Home", comment: "Home")
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(R.nib.productCell)

        // add activity indicator
        initialActivityIndicator.center = view.center
        view.addSubview(initialActivityIndicator)
        view.bringSubview(toFront: initialActivityIndicator)

        // add reload btn
        reloadBtn.center = view.center
        view.addSubview(reloadBtn)
        view.bringSubview(toFront: reloadBtn)
        reloadBtn.isHidden = true

        tableView.dataSource = nil
        dataSource = RxTableViewSectionedReloadDataSource<ProductSection>(
            configureCell: { (_, table, idxPath, item) in
                let cellId = R.nib.productCell.identifier
                guard let cell = table.dequeueReusableCell(withIdentifier: cellId, for: idxPath) as? ProductCell else {
                    fatalError("Dequeueing \(cellId) failed")
                }
                cell.configure(with: item)
                return cell
        }, titleForHeaderInSection: { [unowned self] _, _ in
            let translated = String.localizedStringWithFormat(NSLocalizedString("(%i) results", comment: "%i results"), self.viewModel.totalResultsCount)
            return translated
        })
        viewModel.products
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Product.self)
            .subscribe(onNext: { [weak self] product in
                let viewModel = ProductDetailViewModel(product: product)
                let vc = ProductDetailVC.createWith(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.error
            .drive(onNext: { [weak self] error in
                self?.showAlert(message: error.localizedDescription)
                if self?.initialLoadingDone ?? false {
                    self?.reloadBtn.isHidden = false
                }
            })
            .disposed(by: disposeBag)

        viewModel.loadProducts()

        tableView.tableFooterView = footerView
        tableView.tableFooterView?.isHidden = true

        viewModel.loadingMoreData
            .drive(onNext: { [weak self] status in
                self?.tableView.tableFooterView?.isHidden = !status
            })
            .disposed(by: disposeBag)
        viewModel.initialLoadingDone
            .drive(onNext: { [weak self] _ in
                self?.initialLoadingDone = true
                self?.reloadBtn.isHidden = true
                self?.initialActivityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)

        reloadBtn.rx.tap
            .throttle(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.loadProducts()
            })
            .disposed(by: disposeBag)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // lazy loading when last row is reached
        if indexPath.row == dataSource[0].items.count - 1 {
            tableView.tableFooterView?.isHidden = false
            viewModel.loadProducts()
        }
    }

    private func showAlert(with title: String = "", message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okTitle = NSLocalizedString("OK", comment: "OK")
        let ok = UIAlertAction(title: okTitle, style: .cancel)
        alertController.addAction(ok)
        present(alertController, animated: true)
    }
}
