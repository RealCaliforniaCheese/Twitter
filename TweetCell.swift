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
    
    var tweet: Tweet! {
        didSet {
            print((tweet.user?.profileImageURL!)!)
            // profileImage.setImageWithURL((tweet.user?.profileImageURL!)!)
            userLabel.text = tweet.user!.name!
            statusTextLabel.text = tweet.text
            createdAtLabel.text = tweet.createdAtString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}