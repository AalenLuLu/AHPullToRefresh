//
//  AHRefreshHeader.swift
//  AHPullToRefreshDemo
//
//  Created by Aalen on 16/8/26.
//  Copyright © 2016年 Aalen. All rights reserved.
//

import UIKit

public enum AHRefreshState {
	case Stoped, Triggered, Loading, Success, Failed, NoMore
}

public enum AHRefreshResult {
	case Success, Failed, NoMore
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
	
	private var originalInsetTop: CGFloat = 0
	
	public var state = AHRefreshState.Stoped
	
	public weak var scrollView: UIScrollView?
	
	public var triggerRefreshAction: (() -> Void)?
	
	// MARK: - interface
	
	public func getOriginalInsetTop() -> CGFloat {
		return originalInsetTop
	}
	
	public func stopAnimating(result: AHRefreshResult, showResult: Bool) {
		if showResult {
			
			switch result {
				case .Success:
					setRefresh(.Success)
				case .Failed:
					setRefresh(.Failed)
				case .NoMore:
					setRefresh(.NoMore)
			}
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(timeIntervalForShowSuccessFailed() * NSTimeInterval(NSEC_PER_SEC))), dispatch_get_main_queue(), { 
				self.setRefresh(.Stoped)
			})
			
		} else {
			setRefresh(.Stoped)
		}
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
	
	private func scrollViewDidScroll(contentOffset: CGPoint) {
		if let scrollView = scrollView {
			if .Loading != state {
				
				let threshold = self.frame.origin.y - originalInsetTop
				
				if !scrollView.dragging && .Triggered == state {
					setRefresh(.Loading)
				} else if contentOffset.y >= threshold && scrollView.dragging && .Stoped != state {
					setRefresh(.Stoped)
				} else if contentOffset.y < threshold && scrollView.dragging && .Stoped == state {
					originalInsetTop = scrollView.contentInset.top
					setRefresh(.Triggered)
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
	
	private func setRefresh(state: AHRefreshState) {
		
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
			if previousState == .Triggered {
				if let action = triggerRefreshAction {
					action()
				}
			}
		case .Triggered:
			layoutHeaderForTriggered()
		case .Success:
			layoutHeaderForSuccess()
		case .Failed:
			layoutHeaderForFailed()
		case .NoMore:
			layoutHeaderForNoMore()
		}
	}
	
	private func resetScrollViewContentInsets() {
		if let scrollView = scrollView {
			var insets = scrollView.contentInset
			insets.top = originalInsetTop
			setScrollViewContentInsets(insets)
		}
	}
	
	private func setScrollViewContentInsetsForLoading() {
		if let scrollView = scrollView {
			let offset = originalInsetTop + self.bounds.size.height
			var insets = scrollView.contentInset
			insets.top = offset
			setScrollViewContentInsets(insets)
		}
	}
	
	private func setScrollViewContentInsets(insets: UIEdgeInsets) {
		UIView.animateWithDuration(timeIntervalForScrollAnimate(), delay: 0, options: [.BeginFromCurrentState, .AllowUserInteraction], animations: {
				if let scrollView = self.scrollView {
					scrollView.contentInset = insets
				}
			}, completion: nil)
	}

	private func registerObserve(view: UIView) {
		view.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
	}
	
	private func unregisterObserve(view: UIView) {
		view.removeObserver(self, forKeyPath: "contentOffset")
	}
	
	// MARK: - load resource
	
	public func localizedString(key: String) -> String? {
		
		var language = NSLocale.preferredLanguages()[0]
		if language.hasPrefix("en") {
			language = "en"
		} else if language.hasPrefix("zh") {
			language = "zh"
		} else {
			language = "en"
		}
		
		if let bundle = NSBundle(path: NSBundle(path: NSBundle(forClass: self.dynamicType).pathForResource("AHRefresh", ofType: "bundle")!)!.pathForResource(language, ofType: "lproj")!) {
			let string = bundle.localizedStringForKey(key, value: nil, table: nil)
			return string
		}
		return nil
	}
	
	public func arrowImage() -> UIImage? {
		let scale = UIScreen.mainScreen().scale
		var name = "arrow"
		if 1 < scale && scale < 3 {
			name += "@2x"
		} else if 2 < scale {
			name += "@3x"
		}
		let path = NSBundle(path: NSBundle(forClass: self.dynamicType).pathForResource("AHRefresh", ofType: "bundle")!)?.pathForResource(name, ofType: "png")
		return UIImage(contentsOfFile: path!)
	}
	
	// MARK: - subclass must override
	
	public func layoutHeaderForLoading() {
		fatalError("subclass must override")
	}
	
	public func layoutHeaderForStoped() {
		fatalError("subclass must override")
	}
	
	public func layoutHeaderForTriggered() {
		fatalError("subclass must override")
	}
	
	public func layoutHeaderForSuccess() {
		fatalError("subclass must override")
	}
	
	public func layoutHeaderForFailed() {
		fatalError("subclass must override")
	}
	
	public func layoutHeaderForNoMore() {
		fatalError("subclass must override")
	}
	
	// MARK: - subclass can override
	
	public func timeIntervalForShowSuccessFailed() -> NSTimeInterval {
		return 3
	}
	
	public func timeIntervalForScrollAnimate() -> NSTimeInterval {
		return 0.25
	}
}
