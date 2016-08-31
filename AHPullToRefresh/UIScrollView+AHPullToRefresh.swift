//
//  UIScrollView+AHPullToRefresh.swift
//  AHPullToRefreshDemo
//
//  Created by Aalen on 16/8/26.
//  Copyright © 2016年 Aalen. All rights reserved.
//

import UIKit

var headerAssociatedKey = "com.aalen.pulltorefresh.header"

public extension UIScrollView {
	
	public func addPullToRefresh(header: AHRefreshHeader, action: () -> Void) {
		
		removePullToRefresh()
		
		var frame = header.frame
		frame.origin.x = (self.bounds.size.width - frame.size.width) * 0.5
		frame.origin.y = -frame.size.height
		header.frame = frame
		headerView = header
		headerView!.scrollView = self
		headerView!.triggerRefreshAction = action
		
		self.addSubview(headerView!)
	}
	
	public func removePullToRefresh() {
		if let header = headerView {
			
			//restore...
			var inset = self.contentInset
			inset.top = header.originalInsetTop
			self.contentInset = inset
			
			//remove...
			header.removeFromSuperview()
			header.scrollView = nil
			header.triggerRefreshAction = nil
			headerView = nil
		}
	}
	
	public var headerView: AHRefreshHeader? {
		
		get {
			return objc_getAssociatedObject(self, &headerAssociatedKey) as? AHRefreshHeader
		}
		
		set(newHeader) {
			objc_setAssociatedObject(self, &headerAssociatedKey, newHeader, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}
