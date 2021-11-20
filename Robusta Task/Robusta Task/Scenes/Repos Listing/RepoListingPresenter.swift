//
//  RepoListingPresenter.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 19/11/2021.
//

import Foundation

protocol RepoListingPresenter {
    func attach(view: RepoListingView)
    func configure(cell: RepoCell, indexPath: IndexPath)
    var repoArrayCount: Int? {get}
}

class RepoListingPresenterImp: RepoListingPresenter {
    
    private var view: RepoListingView?
    private let requestManager = RequestManager.shared
    private var reposArray : [Repository] = []
    
    var repoArrayCount: Int? {
        return reposArray.count
    }
    
    func attach(view: RepoListingView) {
        self.view = view
        viewDidAttach()
    }
    
    private func viewDidAttach(){
        getRepos()
    }
    
    func configure(cell: RepoCell, indexPath: IndexPath) {
        let repo = reposArray[indexPath.row]
        let repoName = repo.name
        let ownerName = repo.owner.name
        let ownerAvatarUrl = repo.owner.avatarUrl
        cell.display(repoName: repoName, ownerName: ownerName, ownerAvatarUrl: ownerAvatarUrl, creationDate: "NIL")
    }
    
    private func getRepos() {
        self.view?.showShimmering()
        let getReposEndpoint = Endpoint(method: .get, path: .repos, headers: headers)
        
        requestManager.request(endpoint: getReposEndpoint) { data, error in
            if let error = error {
                // handle error
                return
            }
            
            
            if let jsonData = data {
                do {
                    let repos = try JSONDecoder().decode([Repository].self, from: jsonData)
                    self.reposArray = repos
                    self.view?.hideShimmering()
                    self.view?.reloadTableView()
                } catch let error {
                   // handle parsing error
                }
            }
            
        }
        
    }
}
