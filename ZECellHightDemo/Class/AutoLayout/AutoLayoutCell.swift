//
//  AutoLayoutCell.swift
//  ZECellHightDemo
//
//  Created by 胡春源 on 16/5/23.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit
import WebImage
class AutoLayoutCell: UITableViewCell {

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var buttomLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setModel(model:NewsModel){
        self.topImageView.sd_setImageWithURL(NSURL(string: model.image))
        self.buttomLabel.text = model.title
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
