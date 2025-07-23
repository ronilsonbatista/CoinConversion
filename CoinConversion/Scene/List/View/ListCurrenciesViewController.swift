//
//  ListCurrenciesViewController.swift
//  CoinConversion
//
//  Created by Ronilson Batista on 19/07/20.
//  Copyright © 2020 Ronilson Batista. All rights reserved.
//

import UIKit

// MARK: - Main
class ListCurrenciesViewController: UITableViewController {
    
    var presenter: ListCurrenciesPresenting
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(presenter: ListCurrenciesPresenting) {
        self.presenter = presenter
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewController lifecycle
extension ListCurrenciesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .colorBackground
        
        setupNavigationBar()
        setupBarButton()
        configureTableView()
        
        presenter.delegate = self
        presenter.fetchListCurrencies(isRefresh: false)
    }
}

// MARK: - Private methods
extension ListCurrenciesViewController {
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        tableView.sectionHeaderHeight = 22
        tableView.sectionFooterHeight = 22
        tableView.bouncesZoom = false
        tableView.clipsToBounds = true
        tableView.clearsContextBeforeDrawing = false
        tableView.dataSource = self
        tableView.delegate = self
        
        registerTableViewCells()
    }
    
    private func setupNavigationBar() {
        configureNavigationBar(largeTitleColor: .white,
                               backgoundColor: .colorDarkishPink,
                               tintColor: .white,
                               title: "Lista de moedas",
                               preferredLargeTitle: true,
                               isSearch: true,
                               searchController: setupSearchController()
        )
    }
    
    private func setupBarButton() {
        let button = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshButtonTouched(sender:))
        )
        button.tintColor = .white
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func refreshButtonTouched(sender: UIBarButtonItem) {
        presenter.fetchListCurrencies(isRefresh: true)
    }
    
    private func doLoading(action: UIAlertAction) {
        presenter.fetchListCurrencies(isRefresh: true)
    }
    
    private func setupSearchController() -> UISearchController {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        
        let searchBar = searchController.searchBar
        searchBar.tintColor = .white
        searchBar.barTintColor = .white
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .colorGrayPrimary
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.clipsToBounds = true
        
        return searchController
    }
    private func registerTableViewCells() {
        tableView.register(
            ListCurrenciesViewCell.self,
            forCellReuseIdentifier: ListCurrenciesViewCell.identifier
        )
        tableView.register(
            EmptySearchViewCell.self,
            forCellReuseIdentifier: EmptySearchViewCell.identifier
        )
        tableView.register(
            ListCurrenciesSectionViewCell.self,
            forHeaderFooterViewReuseIdentifier: ListCurrenciesSectionViewCell.identifier
        )
    }
}

// MARK: - UISearchResultsUpdating
extension ListCurrenciesViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        presenter.searchListCurrencies(with: text)
    }
}

// MARK: - UITableViewDataSource
extension ListCurrenciesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.listCurrencies.count == 0 { return 1 }
        return presenter.listCurrencies.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ListCurrenciesSectionViewCell.identifier) as? ListCurrenciesSectionViewCell else {
            fatalError("Couldn't dequeue \(ListCurrenciesSectionViewCell.identifier)")
        }
        
        if !presenter.isSorted {
            header.setupRadioButtons(selectedTag: 0)
        }
        
        header.delegate = self
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.listCurrencies.count == 0 {
            guard let cell = tableView.dequeueReusableCell( withIdentifier: EmptySearchViewCell.identifier, for: indexPath) as? EmptySearchViewCell else {
                fatalError("Couldn't dequeue \(ListCurrenciesViewCell.identifier)")
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListCurrenciesViewCell.identifier, for: indexPath)
                as? ListCurrenciesViewCell else {
            
            fatalError("Couldn't dequeue \(ListCurrenciesViewCell.identifier)")
        }
        
        let currencies = presenter.listCurrencies[indexPath.row]
        cell.bind( name: currencies.name, currency: currencies.code)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.keyboardDismissMode = .onDrag
        searchController.searchBar.endEditing(true)
        searchController.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let currencies = self.presenter.listCurrencies[indexPath.row]
            self.presenter.chooseCurrency(code:currencies.code, name: currencies.name)
        }
    }
}

// MARK: - UITableViewDelegate
extension ListCurrenciesViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 82
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.listCurrencies.isEmpty ? 230 : 100
    }
}

// MARK: - ListCurrenciesSectionViewCellDelegate
extension ListCurrenciesViewController: ListCurrenciesSectionViewCellDelegate {
    func didTapSortBy(_ sortType: SortType) {
        presenter.fetchListSorted(by: sortType, currencies: presenter.listCurrencies)
    }
}

// MARK: - ListCurrenciesPresenterDelegate
extension ListCurrenciesViewController: ListCurrenciesPresenterDelegate {
    func didStartLoading() {
        showActivityIndicator()
    }
    
    func didHideLoading() {
        hideActivityIndicator()
    }
    
    func didReloadData() {
        self.tableView.reloadData()
    }
    
    func didFail(with title: String, message: String, buttonTitle: String, noConnection: Bool, dataSave: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        if noConnection && !dataSave {
            alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: doLoading))
        } else {
            alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
}

