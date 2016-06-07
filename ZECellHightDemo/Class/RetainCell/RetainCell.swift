//
//  RetainCell.swift
//  ZECellHightDemo
//
//  Created by 胡春源 on 16/5/23.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class RetainCell: UITableViewCell {

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var buttomLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setModel(model:NewsModel){
        self.topImageView.sd_setImageWithURL(NSURL(string: model.image))
        
        self.buttomLabel.text = model.title
        // 下面两个方法都是必要的
        self.buttomLabel.layoutIfNeeded()
        self.buttomLabel.sizeToFit() // 让label自适应
        // 更改 contentView.frame
        var rect = self.contentView.frame
        rect.size.height = CGRectGetMaxY(buttomLabel.frame) + 8
        self.contentView.frame = rect
    }
    // 最好新写一个方法,如果都走赋值方法的话会容易引发问题
    func getCellHeight(model:NewsModel) -> CGFloat{
        self.buttomLabel.text = model.title
        // 下面两个方法都是必要的
        self.buttomLabel.layoutIfNeeded()
        self.buttomLabel.sizeToFit() // 让label自适应
        // 更改 contentView.frame
        var rect = self.contentView.frame
        rect.size.height = CGRectGetMaxY(buttomLabel.frame) + 8
        self.contentView.frame = rect
        return self.contentView.frame.height
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
