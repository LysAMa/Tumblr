//
//  PhotoCellTableViewCell.swift
//  Tumblr
//
//  Created by MacBookPro9 on 9/16/18.
//  Copyright © 2018 MacBookPro9. All rights reserved.
//

import AlamofireImage
import UIKit

class PhotoCellTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
