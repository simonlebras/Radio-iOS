//
//  RadioListViewController.swift
//  RadioFrance
//
//  Created by Simon Le Bras on 31/03/2018.
//  Copyright © 2018 Simon Le Bras. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class RadioListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var viewModel: RadioListViewModel!
    
    var appSchedulers: AppSchedulers!
    
    private let disposeBag = DisposeBag()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("SearchPlaceholder", comment: "Search placeholder")
        
        return searchController
    }()
    
    private var radios = [Radio]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.appinjector.inject(self)
        
        viewModel.requestState
            .observeOn(MainScheduler.instance)
            .bind { [unowned self] in
                switch $0 {
                case .loading:
                    self.showActivityIndicatorView()
                case .complete:
                    self.showTableView()
                    self.showSearchController()
                case .error:
                    self.showErrorView()
                case .idle:
                    return
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.fetchRadios
            .do(onNext: { [unowned self] in self.radios = $0 })
            .drive(tableView.rx.items(cellIdentifier: "RadioCell", cellType: RadioCell.self)) { [unowned self] (_, radio, cell) in
                cell.radioNameLabel.text = radio.name
                cell.radioDescriptionLabel.text = radio.description
                cell.radioLogoImageView.sd_setImage(with: URL(string: radio.logo), placeholderImage: UIImage(named: "RadioPlaceholderIcon"))
                
                if let currentRadio = self.viewModel.playerMetadata.value, currentRadio == radio {
                    cell.isSelected = true
                } else {
                    cell.isSelected = false
                }
            }
            .disposed(by:disposeBag)
        
        viewModel.playerMetadata
            .bind(onNext: { [unowned self] _ in
                if !self.tableView.isHidden {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind { [unowned self] in
                self.viewModel.play(radio: self.radios[$0.row])
            }
            .disposed(by: disposeBag)
        
        Observable
            .concat(
                searchController.searchBar.rx.text.orEmpty.take(1),
                searchController.searchBar.rx.text.orEmpty.debounce(0.2, scheduler: appSchedulers.computation)
            )
            .debounce(0.2, scheduler: appSchedulers.computation)
            .map{ $0.trimmingCharacters(in: .whitespaces).lowercased() }
            .distinctUntilChanged()
            .bind(to: viewModel.searchRadioQuery)
            .disposed(by: disposeBag)
        
        searchController.rx.didDismiss
            .map { "" }
            .bind(to: viewModel.searchRadioQuery)
            .disposed(by: disposeBag)
        
        tryAgainButton.rx.tap
            .bind{ [unowned self] in self.viewModel.retryRadioFetching() }
            .disposed(by: disposeBag)
    }
    
    private func showActivityIndicatorView() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        tableView.isHidden = true
        
        errorView.isHidden = true
    }
    
    private func showTableView() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        
        tableView.isHidden = false
        
        errorView.isHidden = true
    }
    
    private func showSearchController() {
        if #available(iOS 11.0, *) {
            guard let parent = parent else {
                preconditionFailure("Failed to find a parent ViewController.")
            }
            
            parent.navigationItem.searchController = searchController
            parent.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
    }
    
    private func showErrorView() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
        
        tableView.isHidden = true
        
        errorView.isHidden = false
    }
}

extension RadioListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isSelected == true {
            cell.isSelected = true
        }else{
            cell.isSelected = false
        }
    }
}
