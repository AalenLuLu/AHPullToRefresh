//
//  TextHeaderDemoTableViewController.swift
//  AHPullToRefreshDemo
//
//  Created by Aalen on 16/9/1.
//  Copyright © 2016年 Aalen. All rights reserved.
//

import UIKit

class TextHeaderDemoTableViewController: UITableViewController {

	var dataList = [String]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		self.tableView.rowHeight = 50
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		
		let refreshHeader = AHRefreshTextHeader(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
		
		tableView.addPullToRefresh(refreshHeader) {
			print("loading...")
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
				print("finished...")
				refreshHeader.stopAnimating(.Success, showResult: false)
			})
		}
		
		dataList.append("1")
		dataList.append("2")
		dataList.append("3")
		dataList.append("4")
		dataList.append("5")
		dataList.append("6")
		dataList.append("7")
		dataList.append("8")
		dataList.append("9")
		dataList.append("10")
		dataList.append("11")
		dataList.append("12")
		dataList.append("13")
		dataList.append("14")
		dataList.append("15")
		dataList.append("16")
		dataList.append("17")
		dataList.append("18")
		dataList.append("19")
		dataList.append("20")
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
        return dataList.count
    }

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
		
		// Configure the cell...
		cell.textLabel?.text = dataList[indexPath.row]
		
		return cell
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
