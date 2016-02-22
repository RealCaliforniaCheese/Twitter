//
//  TweetCell.swift
//  Twitter
//
//  Created by Che Chao Hsu on 2/11/16.
//  Copyright © 2016 Che Chao Hsu. All rights reserved.
//

import UIKit
import NSDateMinimalTimeAgo

protocol TweetCellDelegate {
    func tweetCell( tweetCell: TweetCell, didUpdateTweetCell tweetUpdated:Bool )
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favouritesCountLabel: UILabel!
    
    var delegate: TweetCellDelegate?
    var retweeted = false
    var favorited = false
    
    var tweet: Tweet! {
        didSet {
            profileImage.setImageWithURL(tweet.user!.profileImageURL!)
            userLabel.text = tweet.user!.name!
            screenNameLabel.text = "@\(tweet.user!.screenname!)"
            createdAtLabel.text = tweet.createdAt?.timeAgo()
            statusTextLabel.text = tweet.text; statusTextLabel.sizeToFit()
            retweetCountLabel.text = String(tweet.retweetCount!)
            favouritesCountLabel.text = String(tweet.favouritesCount!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
        
        // iOS not wrapping, then wrapping after scroll down
        userLabel.preferredMaxLayoutWidth = userLabel.frame.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReply(sender: AnyObject) {
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if !retweeted {
            TwitterClient.sharedInstance.retweetStatus(tweet.id) { error in
                self.retweeted = true
                self.tweet.retweetCount! += 1
                self.retweetButton.setImage(UIImage(named: "retweet-action-on-pressed"), forState: .Normal)
                // reset count
                self.tweet.retweetCount = self.tweet.retweetCount < 0 ? 0 : self.tweet.retweetCount
                self.retweetCountLabel.text = "\(self.tweet.retweetCount!)"
            }
        } else {
            TwitterClient.sharedInstance.unretweetStatus(tweet.id) { error in
                self.retweeted = false
                self.tweet.retweetCount! -= 1
                self.retweetButton.setImage(UIImage(named: "retweet-action"), forState: .Normal)
                // reset count
                self.tweet.retweetCount = self.tweet.retweetCount < 0 ? 0 : self.tweet.retweetCount
                self.retweetCountLabel.text = "\(self.tweet.retweetCount!)"
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if !favorited {
            TwitterClient.sharedInstance.likeStatus(tweet.id) { errror in
                self.favorited = true
                self.tweet.favouritesCount! += 1
                self.favoriteButton.setImage(UIImage(named: "like-action-on-pressed"), forState: .Normal)
                self.delegate?.tweetCell(self, didUpdateTweetCell: true)
                self.tweet.favouritesCount = self.tweet.favouritesCount < 0 ? 0 : self.tweet.favouritesCount
                self.favouritesCountLabel.text = "\(self.tweet.favouritesCount!)"
            }
        } else {
            TwitterClient.sharedInstance.unlikeStatus(tweet.id) { error in
                self.favorited = false
                self.tweet.favouritesCount! -= 1
                self.favoriteButton.setImage(UIImage(named: "like-action"), forState: .Normal)
                self.tweet.favouritesCount = self.tweet.favouritesCount < 0 ? 0 : self.tweet.favouritesCount
                self.favouritesCountLabel.text = "\(self.tweet.favouritesCount!)"
            }
        }
    }
}