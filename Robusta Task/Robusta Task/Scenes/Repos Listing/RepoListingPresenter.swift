//
//  RepoListingPresenter.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 19/11/2021.
//

import Foundation

protocol RepoListingPresenter {
    var repoArrayCount: Int? {get}
    func attach(view: RepoListingView)
    func configure(cell: RepoCell, indexPath: IndexPath)
    func searchFor(_ word: String?)
    func didPullToRefresh()
    func didInfiniteScroll()
    
}

class RepoListingPresenterImp: RepoListingPresenter {
    
    private var view: RepoListingView?
    private let requestManager = RequestManager.shared
    private var reposOriginalArray : [Repository] = []
    private var reposArray : [Repository] = []
    private var searchWord: String?
    private var currentPage : Int?
    private var lastPage : Int?
    
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
        let creationDate = (repo.creationDate ?? "").descriptiveDate()
        cell.display(repoName: repoName, ownerName: ownerName, ownerAvatarUrl: ownerAvatarUrl, creationDate: creationDate)
    }
    
    func didPullToRefresh() {
        getRepos()
        self.view?.updateTableViewUIEdgeInsets()
    }

    func didInfiniteScroll() {
        if (currentPage ?? 0) < (lastPage ?? 0) {
            let nextPage = (currentPage ?? 0) + 1
            loadRepos(page: nextPage)
        } else {
            self.view?.finishTableViewInfiniteScroll()
            self.view?.removeTableViewUIEdgeInsets()
        }
    }

    func loadRepos(page: Int){
        let firstIndex = (10 * page)
        var lastIndex = firstIndex
        if (lastIndex + 10) <= (reposOriginalArray.count - 1) {
            lastIndex += 10
        }else{
            lastIndex = reposOriginalArray.count
        }
        
        getRepoDetails(fromindex: firstIndex, toIndex: lastIndex)
        
        self.currentPage = page
    }
    
    func searchFor(_ word: String?) {
        searchWord = word
        executeSearch()
    }

    private func executeSearch(){
        if let query = searchWord, query != ""{
            reposArray.removeAll()
            for repo in reposOriginalArray {
                if repo.name.contains(query) {
                    reposArray.append(repo)
                }
            }
            self.view?.reloadTableView()
        } else {
            reposArray = reposOriginalArray
            self.view?.reloadTableView()
        }
    }
    
    private func getRepos() {
//        self.view?.showShimmering()
        let getReposEndpoint = Endpoint(method: .get, path: Path.repos.rawValue, headers: headers)
        
        requestManager.request(endpoint: getReposEndpoint) { data, error in
            if let error = error {
                // handle error
                return
            }
            
            
            if let jsonData = data {
                do {
                    let repos = try JSONDecoder().decode([Repository].self, from: jsonData)
                    self.handleGetReposSuccess(repos: repos)
                } catch let error {
                   // handle parsing error
                }
            }
            
        }
        
    }
    
    func handleGetReposSuccess(repos: [Repository]){
        self.reposOriginalArray = repos
        self.currentPage = 0
        self.lastPage = Int(Double(repos.count / 10).rounded(.up)) - 1
        self.loadRepos(page: 0)
    }
    
    private func getRepoDetails(fromindex: Int, toIndex: Int){
        let getRepoDetailsGroup = DispatchGroup()

        for i in fromindex..<toIndex {
            getRepoDetailsGroup.enter()
            let repo = reposOriginalArray[i]
            let path = Path.repoDetails.rawValue + repo.fullName
            let getRepoDetailsEndpoint = Endpoint(method: .get, path: path, headers: headers)
            
            requestManager.request(endpoint: getRepoDetailsEndpoint) { data, error in
                if let _ = error {
                    return
                }
                
                if let jsonData = data {
                    do {
                        let repoDetails = try JSONDecoder().decode(Repository.self, from: jsonData)
                        self.reposOriginalArray[i] = repoDetails
                    } catch {
                        return
                    }
                }
                getRepoDetailsGroup.leave()
            }
        }
        
        getRepoDetailsGroup.notify(queue: .main) {
            self.reposArray = Array(self.reposOriginalArray.prefix(toIndex))
            if fromindex == 0 {
                // This the the first load after the Get All Repos Request
                self.view?.hideShimmering()
                self.view?.reloadTableView()
            }else {
                // This is infinite Scroll
                self.view?.finishTableViewInfinteScrollWithCompletion()
            }
        }
    }
}
