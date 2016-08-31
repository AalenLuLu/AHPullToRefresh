//
//  AHRefreshHeader.swift
//  AHPullToRefreshDemo
//
//  Created by Aalen on 16/8/26.
//  Copyright © 2016年 Aalen. All rights reserved.
//

import UIKit

public enum AHRefreshState {
	case Stoped, Trigger, Loading
}

public class AHRefreshHeader: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	// MARK: - property
	
	public var originalInsetTop: CGFloat = 0
	
	public var state = AHRefreshState.Stoped
	
	public weak var scrollView: UIScrollView?
	
	public var triggerRefreshAction: (() -> Void)?
	
	// MARK: - interface
	
	public func stopAnimating() {
		setRefresh(.Stoped)
	}
	
	// MARK: - view handle
	
	public override func willMoveToSuperview(newSuperview: UIView?) {
		originalInsetTop = 0
		
		if let oldSuperView = self.superview {
			unregisterObserve(oldSuperView)
		}
		
		if let superView = newSuperview {
			registerObserve(superView)
		} else {
			//remove from super view
		}
	}
	
	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if "contentOffset" == keyPath {
			if let change = change {
				if let contentOffset = change[NSKeyValueChangeNewKey]?.CGPointValue() {
					scrollViewDidScroll(contentOffset)
				}
			}
		}
	}
	
	func scrollViewDidScroll(contentOffset: CGPoint) {
		if let scrollView = scrollView {
			if .Loading != state {
				
				let threshold = self.frame.origin.y - originalInsetTop
				
				if !scrollView.dragging && .Trigger == state {
					setRefresh(.Loading)
				} else if contentOffset.y >= threshold && scrollView.dragging && .Stoped != state {
					setRefresh(.Stoped)
				} else if contentOffset.y < threshold && scrollView.dragging && .Stoped == state {
					originalInsetTop = scrollView.contentInset.top
					setRefresh(.Trigger)
				} /*else if contentOffset.y >= scrollOffsetThreshold && .Stoped != state {
					state = .Stoped
				}*/
				
			} else {
				
				let offset = originalInsetTop + self.bounds.size.height
				var contentInset = scrollView.contentInset
				contentInset.top = offset
				scrollView.contentInset = contentInset
			}
		}
	}
	
	func setRefresh(state: AHRefreshState) {
		
		if self.state == state {
			return
		}
		
		let previousState = self.state
		self.state = state
		
		switch state {
		case .Stoped:
			layoutHeaderForStoped()
			resetScrollViewContentInsets()
		case .Loading:
			layoutHeaderForLoading()
			setScrollViewContentInsetsForLoading()
			if previousState == .Trigger {
				if let action = triggerRefreshAction {
					action()
				}
			}
		case .Trigger:
			layoutHeaderForTrigger()
		}
	}
	
	public func resetScrollViewContentInsets() {
		if let scrollView = scrollView {
			var insets = scrollView.contentInset
			insets.top = originalInsetTop
			setScrollViewContentInsets(insets)
		}
	}
	
	public func setScrollViewContentInsetsForLoading() {
		if let scrollView = scrollView {
			let offset = originalInsetTop + self.bounds.size.height
			var insets = scrollView.contentInset
			insets.top = offset
			setScrollViewContentInsets(insets)
		}
	}
	
	public func setScrollViewContentInsets(insets: UIEdgeInsets) {
		UIView.animateWithDuration(0.25, delay: 0, options: [.BeginFromCurrentState, .AllowUserInteraction], animations: {
				if let scrollView = self.scrollView {
					scrollView.contentInset = insets
				}
			}, completion: nil)
	}

	public func registerObserve(view: UIView) {
		view.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
	}
	
	public func unregisterObserve(view: UIView) {
		view.removeObserver(self, forKeyPath: "contentOffset")
	}
	
	// MARK: - subclass must override
	
	public func layoutHeaderForLoading() {
		fatalError("subclass must override")
	}
	
	public func layoutHeaderForStoped() {
		fatalError("subclass must override")
	}
	
	public func layoutHeaderForTrigger() {
		fatalError("subclass must override")
	}
}
