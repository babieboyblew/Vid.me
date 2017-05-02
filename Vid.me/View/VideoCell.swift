//
//  VideoCell.swift
//  Vid.me
//
//  Created by Vladimir Abdrakhmanov on 5/1/17.
//  Copyright © 2017 V.Abdrakhmanov. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var likeLabel: UILabel!
	@IBOutlet weak var activityView: UIActivityIndicatorView!
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
