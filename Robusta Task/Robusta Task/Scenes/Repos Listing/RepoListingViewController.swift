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
}

class RepoListingViewController: UIViewController, RepoListingView {

    @IBOutlet weak var reposTableView: UITableView!
    
    private var repoCellId = "RepoTableViewCell"
    private var loadingTableData = true
    var presenter: RepoListingPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        setupViews()
    }

    func setupViews(){
        setupTableView()
    }
    
    func setupTableView() {
        reposTableView.scrollsToTop = true
        reposTableView.rowHeight = UITableView.automaticDimension
        reposTableView.estimatedRowHeight = 70
        let repoCellNib = UINib(nibName: repoCellId, bundle: nil)
        reposTableView.register(repoCellNib, forCellReuseIdentifier: repoCellId)
    }
    
    func showShimmering() {
        loadingTableData = true
    }
    
    func hideShimmering() {
        loadingTableData = false
    }
    
    func reloadTableView(){
        reposTableView.reloadData()
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
        // navigate to details
    }
}
