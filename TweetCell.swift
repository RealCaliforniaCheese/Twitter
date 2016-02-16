//
//  TweetCell.swift
//  Twitter
//
//  Created by Che Chao Hsu on 2/11/16.
//  Copyright © 2016 Che Chao Hsu. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favouritesCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            profileImage.setImageWithURL(tweet.user!.profileImageURL!)
            userLabel.text = tweet.user!.name!
            statusTextLabel.text = tweet.text
            createdAtLabel.text = tweet.createdAtString
            retweetCountLabel.text = String(tweet.retweetCount!)
            favouritesCountLabel.text = String(tweet.user!.favouritesCount!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}