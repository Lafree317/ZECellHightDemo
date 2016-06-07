//
//  NewsModel.swift
//  ZECellHightDemo
//
//  Created by 胡春源 on 16/5/23.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

// 知乎日报首页model
struct HomeModel {
    let top_stories:Array<NewsModel> // 置顶内容
    let date:String // 日期
    let stories:Array<NewsModel> // 今日内容
    
    // 返回一整个数组
    func getDataArr() -> Array<NewsModel> {
        return top_stories + stories
    }
}

struct NewsModel {
    let id:Int
    let title:String // 标题
    let image:String // 图片地址
    let type:Int
    let ga_prefix:String
    
    // 获取cell的高度
    func getCellHeight() -> CGFloat {
        var cellHeight:CGFloat = 0
        let imageHeight:CGFloat = 200
        let margin:CGFloat = 8 // label距离上下左右各为8
        
        // 计算title高度方法
        let size = CGSizeMake(UIScreen.mainScreen().bounds.width - margin*2 ,0)
        let titleHeight = title.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(20)], context: nil).height
        
        cellHeight = imageHeight + titleHeight + margin*2 + 1 //+1才换行...可能是cell分割线吧....
        
        return cellHeight
    }
}
