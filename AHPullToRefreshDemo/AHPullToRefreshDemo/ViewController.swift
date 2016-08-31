//
//  ViewController.swift
//  AHPullToRefreshDemo
//
//  Created by Aalen on 16/8/26.
//  Copyright © 2016年 Aalen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationController?.navigationBar.alpha = 0.1
		let refreshHeader = AHRefreshHeader(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
		refreshHeader.backgroundColor = UIColor.greenColor()
		
		let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(self.view.bounds), height: CGRectGetHeight(self.view.bounds)), style: .Plain)
		self.view.addSubview(tableView)
		
		tableView.addPullToRefresh(refreshHeader) { 
			print("asdfasdflkj")
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
				print("ffff")
				refreshHeader.resetScrollViewContentInsets()
			})
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

