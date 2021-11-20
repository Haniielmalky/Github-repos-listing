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
    func didSelecetRepo(indexPath: IndexPath)
}

class RepoListingPresenterImp: RepoListingPresenter {
    
    private var view: RepoListingView?
    private let requestManager = RequestManager.shared
    private var reposOriginalArray : [Repository] = []
    private var reposArray : [Repository] = []
    private var searchWord: String?
    private var currentPage : Int?
    private var lastPage : Int?
    private let singlePageCount = 10
    
    var repoArrayCount: Int? {
        guard let currentPage = currentPage else {
            return 0
        }
        let count = currentPage * singlePageCount
        if searchWord != nil {
            if count < reposArray.count {
                return count
            } else {
                return reposArray.count
            }
        } else {
            if count < reposOriginalArray.count {
                return count
            } else {
                return reposOriginalArray.count
            }
        }
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
    
    func didSelecetRepo(indexPath: IndexPath){
        let repo = reposArray[indexPath.item]
        self.view?.navigateToRepoDetailsDetailsView(repo: repo)
    }
    
    func didPullToRefresh() {
        getRepos()
        self.view?.updateTableViewUIEdgeInsets()
    }

    func didInfiniteScroll() {
        if (currentPage ?? 0) < (lastPage ?? 0) {
            if let currentPage = currentPage {
                self.view?.finishTableViewInfinteScrollWithCompletion()
                self.currentPage = currentPage + 1
            }
        } else {
            self.view?.finishTableViewInfiniteScroll()
            self.view?.removeTableViewUIEdgeInsets()
        }
    }
    
    func searchFor(_ word: String?) {
        searchWord = word
        executeSearch()
    }

    private func executeSearch(){
        currentPage = 1
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
        self.currentPage = 1
        self.lastPage = Int(Double(repos.count / singlePageCount).rounded(.up))
        getRepoDetails(isFirstPage: true)
    }
    
    private func getRepoDetails(isFirstPage: Bool = false){
        let getRepoDetailsGroup = DispatchGroup()

        let firstIndex = isFirstPage ? 0 : 10
        let lastIndex = isFirstPage ? 10 : reposOriginalArray.count
        
        for i in firstIndex..<lastIndex{
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
            self.reposArray = self.reposOriginalArray
            if isFirstPage {
                self.view?.hideShimmering()
                self.view?.reloadTableView()
                self.getRepoDetails(isFirstPage: false)
            }
        }
    }
    
}
