![为了好看配张图](http://upload-images.jianshu.io/upload_images/1298596-8d54d23ca10f55a9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#前言
>在iOS开发中UITableView有很多需要注意的坑,这篇文章主要总结一下计算cell高度的几种方式,并且分析一下每种方式的优缺点..请结合demo一起看

#上代码
>因为网络层和Model层是通用的所以提前看一眼
网络层:通用的网络接口,抓取自知乎日报首页..

```
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
        let url =  "http://news-at.zhihu.com/api/4/news/latest"
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
            let type =  jsonArr[i]["type"].intValue
            let ga_prefix = jsonArr[i]["ga_prefix"].stringValue
            let newModel = NewsModel(id: id, title: title, image: image, type: type, ga_prefix: ga_prefix)
            newsArr.append(newModel)
        }
        return newsArr
    }
}
```

>Model层:按照请求返回的json格式创建一个struct

```
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
```
### 通过model计算高度
>Model内生成一个计算方法,通过model内的属性计算高度.这种方式应该是最稳妥的

```
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
```


>缺点:如果计算量太大代码会很难读懂,不好改

### 通过持有Cell计算高度
>给cell赋值的时候直接改变cell的contentView.frame,通过controller里再多持有一个cell,每次需要计算高度的时候给自己持有的也赋值一次然后直接返回cell的高


```
// 现在controller里创建一个cell属性并且初始化
cell = NSBundle.mainBundle().loadNibNamed("RetainCell", owner: self, options: nil).first as! RetainCell
```
```
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
```
```
// 在tableView返回cell高度时
override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return cell.getCellHeight(dataArr[indexPath.row])
}
```


>缺点:每次计算高度时都要给cell赋值两次,性能太低,在某些情况下会对屏幕适配上出问题...网上流传这种方法真是坑人...也许是本菜鸡不会用..希望大家指正

### 通过可视化计算cell高度
>通过AutoLayout的约束给每个控件定义优先级,如果需要再某些地方再次更改高度可以在代码中更改约束的内容然后layoutIfNeed
>先给label的高度设置为>=32

![](http://upload-images.jianshu.io/upload_images/1298596-813121576d0a2f88.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


```
// 然后设置tableView.rowHeight
self.tableView.rowHeight = UITableViewAutomaticDimension
```

```
// 只用设置一个预估高度
override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 258//预估高度
}
```

>缺点:这种方式在我自己敲demo的时候一直在用,还没有碰到缺点...不过按照惯例一定有坑,只是我还没踩到而已..(可能需求太变态的时候不好做)

### 固定高度!
>如果需求全是固定高度的,那该多爽!



### 其他
>本菜鸡在开发中一般自己瞎敲着玩的时候喜欢用AutoLayout的方法,因为在设计cell的时候把约束加号一行代码就可以搞定cell高度了,但是开发公司项目是一般用model计算,一是因为不知道什么时候cell展示就要换样子...二是很多tableview框架是直接需要一个高度...
写这边博客也是顺便练练手,用了Carthage包管理,SwiftyJSON之类的...后续可能会更新一些代码约束计算高度的方法...
如果在本篇博客中发现了什么问题,或者疑问欢迎和我一起讨论,共同进步XD
