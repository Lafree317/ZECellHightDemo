//
//  AutoLayoutTableViewController.swift
//  ZECellHightDemo
//
//  Created by 胡春源 on 16/5/23.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class AutoLayoutTableViewController: UITableViewController {
    
    var dataArr:Array<NewsModel> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper().getData { (homeModel) in
            self.dataArr += homeModel.getDataArr()
            self.tableView.reloadData()
        }
        self.tableView.registerNib(UINib.init(nibName: "AutoLayoutCell", bundle: nil), forCellReuseIdentifier: "AutoLayoutCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    // 只用设置一个预估高度
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 258//预估高度
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArr.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AutoLayoutCell", forIndexPath: indexPath) as! AutoLayoutCell
        cell.setModel(dataArr[indexPath.row])
        return cell
    }

}
