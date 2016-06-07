//
//  HomeTableViewController.swift
//  ZECellHightDemo
//
//  Created by 胡春源 on 16/5/23.
//  Copyright © 2016年 胡春源. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.rowHeight = 50
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titlesArr.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("home") ?? UITableViewCell(style: .Default, reuseIdentifier: "home")
        cell.textLabel?.text = titlesArr[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var tbVC = UITableViewController()
        
        if indexPath.row == 0 {
            tbVC = RetainTableViewController(style: .Plain)
        }else if indexPath.row == 1{
            tbVC = ModelCaculateTableViewController(style: .Plain)
        }else{
            tbVC = AutoLayoutTableViewController(style: .Plain)
        }
        
        self.showViewController(tbVC, sender: nil)
    }
    let titlesArr = [
        "通过持有Cell计算高度",
        "通过Model计算Cell高度",
        "AutoLayout计算Cell高度",
    ]

}
