//
//  RetainTableViewController.swift
//  ZECellHightDemo
//
//  Created by 胡春源 on 16/5/23.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class RetainTableViewController: UITableViewController {
    var dataArr:Array<NewsModel> = []
    var cell:RetainCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper().getData { (homeModel) in
            self.dataArr += homeModel.getDataArr()
            self.tableView.reloadData()
        }
        self.tableView.registerNib(UINib.init(nibName: "RetainCell", bundle: nil), forCellReuseIdentifier: "RetainCell")
        cell = NSBundle.mainBundle().loadNibNamed("RetainCell", owner: self, options: nil).first as! RetainCell
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
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cell.getCellHeight(dataArr[indexPath.row])
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataArr.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RetainCell", forIndexPath: indexPath) as! RetainCell
        cell.setModel(dataArr[indexPath.row])
        return cell
    }
}
