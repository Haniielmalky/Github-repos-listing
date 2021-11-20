//
//  RepoDetailsViewController.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 20/11/2021.
//

import UIKit

protocol RepoDetailsView {
    func setupRepoContent(repoName: String, visibility: String, description: String, language: String, watcherCount: Int, starCount: Int, forkCount: Int, lastUpdated: String, createdAt: String, issueCount: Int)
}

class RepoDetailsViewController: UIViewController, RepoDetailsView {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var watcherCountLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var issueCountLabel: UILabel!
    @IBOutlet weak var descriptionContainerView: UIView!
    
    var presenter: RepoDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attach(view: self)
        setupViews()
    }

    func setupViews(){
        setupBackButton()
    }
        
    func setupBackButton(isWhite: Bool = false) {
        let backButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 51, height: 44)
        backButton.setImage(#imageLiteral(resourceName: "back"), for: [])
        backButton.transform = CGAffineTransform(translationX: 50, y: 0)
        backButton.addTarget(self, action: #selector(self.backButtonTapped), for: UIControl.Event.touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }

    func setupRepoContent(repoName: String, visibility: String, description: String, language: String, watcherCount: Int, starCount: Int, forkCount: Int, lastUpdated: String, createdAt: String, issueCount: Int) {
        repoNameLabel.text = repoName
        visibilityLabel.text = visibility
        descriptionLabel.text = description
        languageLabel.text = language
        watcherCountLabel.text = "\(watcherCount)"
        starCountLabel.text = "\(starCount)"
        forkCountLabel.text = "\(forkCount)"
        lastUpdatedLabel.text = lastUpdated
        createdDateLabel.text = createdAt
        issueCountLabel.text = "\(issueCount)"
    }
}
