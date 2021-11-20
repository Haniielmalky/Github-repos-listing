//
//  CustomNavigationController.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 20/11/2021.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let repoListingViewController = self.viewControllers.first as? RepoListingViewController {
            repoListingViewController.presenter = RepoListingPresenterImp()
        }
    }
}
