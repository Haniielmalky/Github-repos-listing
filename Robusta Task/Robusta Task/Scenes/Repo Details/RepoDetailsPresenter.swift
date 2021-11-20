//
//  RepoDetailsPresenter.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 20/11/2021.
//

import Foundation

protocol RepoDetailsPresenter: AnyObject {
    func attach(view: RepoDetailsView)
}

class RepoDetailsPresenterImp: RepoDetailsPresenter {
    
    private var view: RepoDetailsView?
    private var repoDetails: Repository?
    
    init(repo: Repository) {
        self.repoDetails = repo
    }
    
    func attach(view: RepoDetailsView) {
        self.view = view
        didAttach()
    }
    
    func didAttach(){
        setupRepoValues()
    }
    
    func setupRepoValues(){
        if let repo = repoDetails {
            
            let repoName = repo.name
            let visibility = repo.visibility ?? ""
            let desc = repo.description ?? ""
            let lang = repo.language ?? ""
            let watchCount = repo.watchers ?? 0
            let starCount = repo.starCount ?? 0
            let forkCount = repo.forks ?? 0
            let lastUpdated = (repo.lastUpdateDate ?? "").descriptiveDate()
            let createdDate = (repo.creationDate ?? "").descriptiveDate()
            let issueCount = repo.issuesCount ?? 0
            
            self.view?.setupRepoContent(repoName: repoName, visibility: visibility, description: desc, language: lang, watcherCount: watchCount, starCount: starCount, forkCount: forkCount, lastUpdated: lastUpdated, createdAt: createdDate, issueCount: issueCount)
        }
    }
        
}
