//
//  RepoTableViewCell.swift
//  Robusta Task
//
//  Created by Hani El-Malky on 19/11/2021.
//

import UIKit

protocol RepoCell {
    func display(repoName: String, ownerName: String, ownerAvatarUrl: String, creationDate: String)
}

class RepoTableViewCell: UITableViewCell, RepoCell {
    
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var repoCreationDateLabel: UILabel!
    @IBOutlet weak var repoContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        repoContainerView.setShadow()
    }
    
    func display(repoName: String, ownerName: String, ownerAvatarUrl: String, creationDate: String) {
        repoNameLabel.text = repoName
        ownerNameLabel.text = ownerName
        repoCreationDateLabel.text = creationDate
        setOwnerAvatar(imageUrl: ownerAvatarUrl)
    }

    private func setOwnerAvatar(imageUrl: String) {
        let imagePlaceHolder = UIImage(named: "placeholder_img")
        RequestManager.shared.downloadRequest(imageUrl: imageUrl) { (data, error) in
            if let imageData = data, let avatarImage = UIImage(data: imageData) {
                self.ownerAvatarImageView.image = avatarImage
            } else {
                self.ownerAvatarImageView.image = imagePlaceHolder
            }
        }
    }
}
