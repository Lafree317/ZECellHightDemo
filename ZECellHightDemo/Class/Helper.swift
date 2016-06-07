//
//  Helper.swift
//  ZECellHightDemo
//
//  Created by 胡春源 on 16/5/22.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking

typealias HomeModelBlock = (homeModel:HomeModel) -> Void

class Helper: NSObject {
    /**
     抓取知乎日报首页
     
     - parameter callBack: 回调一个HomeModel
     */
    internal func getData(callBack:HomeModelBlock){
        // AFNetWorking请求数据
        let url =  "http://news-at.zhihu.com/api/4/news/latest"
        let manager = AFHTTPSessionManager()
        manager.GET(url, parameters: nil, progress: nil, success: { (dataTask, anyobject) in
            
            let json = JSON(anyobject!)
            let top_stories = self.jsonToNewsArr(json["top_stories"].arrayValue)
            let date = json["date"].stringValue
            let stories = self.jsonToNewsArr(json["stories"].arrayValue)
            let homeModel = HomeModel(top_stories: top_stories, date: date, stories: stories)
            
            callBack(homeModel: homeModel)
        }) { (dataTask, error) in
            // 暂不处理错误
        }
    }
    /**
     传入解析一个json数组,返回一个model数组
     
     - parameter jsonArr: SwiftyJSON解析出来的json数组
     
     - returns: NewsModel数组
     */
    func jsonToNewsArr(jsonArr:[JSON]) -> Array<NewsModel> {
        var newsArr:Array<NewsModel> = []
        for i in 0 ..< jsonArr.count {
            let id = jsonArr[i]["id"].intValue
            let title = jsonArr[i]["title"].stringValue
            var image = jsonArr[i]["image"].stringValue
            // 有的图片是数组,暂时不处理,只取出一张
            if image == "" {
                image = jsonArr[i]["images"].arrayValue[0].stringValue
            }
            let type =  jsonArr[i]["type"].intValue
            let ga_prefix = jsonArr[i]["ga_prefix"].stringValue
            let newModel = NewsModel(id: id, title: title, image: image, type: type, ga_prefix: ga_prefix)
            newsArr.append(newModel)
        }
        return newsArr
    }
}
