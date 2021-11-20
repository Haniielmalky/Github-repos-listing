//
//  RepoListingViewController.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 19/11/2021.
//

import UIKit

protocol RepoListingView {
    func reloadTableView()
    func showShimmering()
    func hideShimmering()
    func finishTableViewInfiniteScroll()
    func finishTableViewInfinteScrollWithCompletion()
    func updateTableViewUIEdgeInsets()
    func removeTableViewUIEdgeInsets()
    func navigateToRepoDetailsDetailsView(repo: Repository)
}

class RepoListingViewController: UIViewController, RepoListingView {
    
    @IBOutlet weak var reposTableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchClearButton: UIButton!
    
    private var repoCellId = "RepoTableViewCell"
    private var loadingTableData = true
    var presenter: RepoListingPresenter!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        setupViews()
    }
    
    func setupViews(){
        setupTableView()
        setupClearButton(hide: true)
        setupRefreshControl()
        setupInfiniteScroll()
    }
    
    func setupTableView() {
        reposTableView.scrollsToTop = true
        reposTableView.rowHeight = UITableView.automaticDimension
        reposTableView.estimatedRowHeight = 70
        let repoCellNib = UINib(nibName: repoCellId, bundle: nil)
        reposTableView.register(repoCellNib, forCellReuseIdentifier: repoCellId)
        reposTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 125, right: 0)
    }
    
    func setupRefreshControl() {
        reposTableView.addSubview(self.refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    func updateTableViewUIEdgeInsets() {
        reposTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 125, right: 0)
    }
    
    func removeTableViewUIEdgeInsets() {
        reposTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc private func refreshData(_ sender: Any) {
        searchTF.text = nil
        setupClearButton(hide: true)
        presenter.didPullToRefresh()
    }
    
    private func setupInfiniteScroll() {
        reposTableView.addInfiniteScroll { (_) in
            self.presenter.didInfiniteScroll()
        }
    }
    
    func finishTableViewInfiniteScroll() {
        reposTableView.finishInfiniteScroll()
    }
    
    func finishTableViewInfinteScrollWithCompletion() {
        reposTableView.finishInfiniteScroll { (tableView) in
            tableView.reloadData()
        }
    }
    
    func setupClearButton(hide: Bool){
        searchClearButton.isHidden = hide
    }
    
    func showShimmering() {
        loadingTableData = true
    }
    
    func hideShimmering() {
        loadingTableData = false
    }
    
    func reloadTableView(){
        self.refreshControl.endRefreshing()
        reposTableView.reloadData()
    }
    
    @IBAction func didClickSearchButton(_ sender: UIButton) {
        self.presenter.searchFor(searchTF.text)
    }
    
    @IBAction func didClickClearSearchButton(_ sender: UIButton) {
        searchTF.text = nil
        self.presenter.searchFor(nil)
        self.setupClearButton(hide: true)
    }
    
    @IBAction func didChangeEditingForSearchTF(_ sender: UITextField) {
        if let query = sender.text, query != "" {
            setupClearButton(hide: false)
            //            if query.count > 1 {
            self.presenter.searchFor(sender.text)
            //            }
        } else {
            setupClearButton(hide: true)
            self.presenter.searchFor(nil)
        }
    }
    
    func navigateToRepoDetailsDetailsView(repo: Repository) {
        let repoDetailsVC = RepoDetailsViewController()
        self.navigationController?.pushViewController(repoDetailsVC, animated: true)
    }
}

extension RepoListingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.repoArrayCount ?? 0
        return loadingTableData ? 7 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RepoTableViewCell = tableView.dequeueReusableCell(withIdentifier: repoCellId, for: indexPath) as! RepoTableViewCell
        Loader.removeLoaderFromViews(cell.contentView.subviews)
        if !loadingTableData {
            presenter.configure(cell: cell, indexPath: indexPath)
        } else {
            Loader.addLoaderToViews(cell.contentView.subviews)
        }
        return cell
    }
}

extension RepoListingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !loadingTableData {
            self.presenter.didSelecetRepo(indexPath: indexPath)
        }
    }
}
