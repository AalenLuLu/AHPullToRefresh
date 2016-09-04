//
//  TableViewController.swift
//  AHPullToRefreshDemo
//
//  Created by Aalen on 16/8/30.
//  Copyright © 2016年 Aalen. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

	var dataList = [String]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		self.tableView.rowHeight = 50
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		
		dataList.append("Text")
		dataList.append("Text_enablegradient")
    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
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
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		let data = dataList[indexPath.row]
		var enableGradient = false
		var name = data
		if data.hasSuffix("_enablegradient") {
			name = data.stringByReplacingOccurrencesOfString("_enablegradient", withString: "")
			enableGradient = true
		}
		
		let className = NSBundle.mainBundle().infoDictionary![String(kCFBundleExecutableKey)] as! String + "." + "AHRefresh" + name + "Header"
		if let demoClass = NSClassFromString(className) as? AHRefreshHeader.Type {
			let viewController = DemoTableViewController(style: .Plain)
			viewController.title = data
			viewController.refreshHeaderClass = demoClass
			viewController.enableGradient = enableGradient
			self.navigationController?.pushViewController(viewController, animated: true)
		}
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
