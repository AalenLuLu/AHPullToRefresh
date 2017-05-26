//
//  AHRefreshHeader.swift
//  AHPullToRefreshDemo
//
//  Created by Aalen on 16/8/26.
//  Copyright © 2016年 Aalen. All rights reserved.
//

import UIKit

public enum AHRefreshState {
	case stoped, triggered, loading, success, failed, noMore
}

public enum AHRefreshResult {
	case success, failed, noMore
}

open class AHRefreshHeader: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	// MARK: - property
	
	open weak var scrollView: UIScrollView?
	open var triggerRefreshAction: (() -> Void)?
	open var state = AHRefreshState.stoped
	open var enableGradient = false
	
	fileprivate var originalInsetTop: CGFloat = 0
	fileprivate var isUserChangeInset = false
	
	required override public init(frame: CGRect) {
		super.init(frame: frame)
		layoutHeaderForStoped()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - interface
	
	open func getOriginalInsetTop() -> CGFloat {
		return originalInsetTop
	}
	
	open func stopAnimating(_ result: AHRefreshResult, showResult: Bool) {
		if showResult {
			
			switch result {
				case .success:
					setRefresh(.success)
				case .failed:
					setRefresh(.failed)
				case .noMore:
					setRefresh(.noMore)
			}
			
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(timeIntervalForShowSuccessFailed() * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { 
				self.setRefresh(.stoped)
			})
			
		} else {
			setRefresh(.stoped)
		}
	}
	
	// MARK: - view handle
	
	open override func willMove(toSuperview newSuperview: UIView?) {
		originalInsetTop = 0
		
		if let oldSuperView = self.superview {
			unregisterObserve(oldSuperView)
		}
		
		if let superView = newSuperview {
			if superView.isKind(of: UIScrollView.self) {
				originalInsetTop = (superView as! UIScrollView).contentInset.top
			}
			registerObserve(superView)
		} else {
			//remove from super view
		}
	}
	
	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if "contentOffset" == keyPath {
			if let change = change {
				if let contentOffset = (change[NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue {
					scrollViewDidScroll(contentOffset)
				}
			}
		} else if "contentInset" == keyPath {
			if isUserChangeInset {
				return
			}
			if let scrollView = scrollView {
				originalInsetTop = scrollView.contentInset.top
			}
		}
	}
	
	fileprivate func scrollViewDidScroll(_ contentOffset: CGPoint) {
		if let scrollView = scrollView {
			if .loading != state {
				
				let threshold = self.frame.origin.y - originalInsetTop
				
				if enableGradient && .stoped == state {
					layoutHeaderForStoped(by: contentOffset.y)
				}
				
				if !scrollView.isDragging && .triggered == state {
					setRefresh(.loading)
				} else if contentOffset.y >= threshold && scrollView.isDragging && .stoped != state {
					setRefresh(.stoped)
				} else if contentOffset.y < threshold && scrollView.isDragging && .stoped == state {
					setRefresh(.triggered)
				} /*else if contentOffset.y >= scrollOffsetThreshold && .Stoped != state {
					state = .Stoped
				}*/
				
			} else {
				
//				let offset = originalInsetTop + self.bounds.size.height
//				var contentInset = scrollView.contentInset
//				contentInset.top = offset
//				scrollView.contentInset = contentInset
			}
		}
	}
	
	fileprivate func setRefresh(_ state: AHRefreshState) {
		
		if self.state == state {
			return
		}
		
		let previousState = self.state
		self.state = state
		
		switch state {
		case .stoped:
			layoutHeaderForStoped()
			resetScrollViewContentInsets()
		case .loading:
			layoutHeaderForLoading()
			setScrollViewContentInsetsForLoading()
			if previousState == .triggered {
				if let action = triggerRefreshAction {
					action()
				}
			}
		case .triggered:
			layoutHeaderForTriggered()
		case .success:
			layoutHeaderForSuccess()
		case .failed:
			layoutHeaderForFailed()
		case .noMore:
			layoutHeaderForNoMore()
		}
	}
	
	fileprivate func resetScrollViewContentInsets() {
		if let scrollView = scrollView {
			var insets = scrollView.contentInset
			insets.top = originalInsetTop
			setScrollViewContentInsets(insets)
		}
	}
	
	fileprivate func setScrollViewContentInsetsForLoading() {
		if let scrollView = scrollView {
			let offset = originalInsetTop + self.bounds.size.height
			var insets = scrollView.contentInset
			insets.top = offset
			setScrollViewContentInsets(insets)
		}
	}
	
	fileprivate func setScrollViewContentInsets(_ insets: UIEdgeInsets) {
		isUserChangeInset = true
		
		UIView.animate(withDuration: timeIntervalForScrollAnimate(), delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
				if let scrollView = self.scrollView {
					scrollView.contentInset = insets
				}
		}) { (result) in
			self.isUserChangeInset = false
		}
	}

	fileprivate func registerObserve(_ view: UIView) {
		view.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
		view.addObserver(self, forKeyPath: "contentInset", options: .new, context: nil)
	}
	
	fileprivate func unregisterObserve(_ view: UIView) {
		view.removeObserver(self, forKeyPath: "contentOffset")
		view.removeObserver(self, forKeyPath: "contentInset")
	}
	
	// MARK: - load resource
	
	open func localizedString(_ key: String) -> String? {
		
		var language = Locale.preferredLanguages[0]
		if language.hasPrefix("en") {
			language = "en"
		} else if language.hasPrefix("zh") {
			language = "zh"
		} else {
			language = "en"
		}
		
		if let bundle = Bundle(path: Bundle(path: Bundle(for: type(of: self)).path(forResource: "AHRefresh", ofType: "bundle")!)!.path(forResource: language, ofType: "lproj")!) {
			let string = bundle.localizedString(forKey: key, value: nil, table: nil)
			return string
		}
		return nil
	}
	
	open func arrowImage() -> UIImage? {
		let scale = UIScreen.main.scale
		var name = "arrow"
		if 1 < scale && scale < 3 {
			name += "@2x"
		} else if 2 < scale {
			name += "@3x"
		}
		let path = Bundle(path: Bundle(for: type(of: self)).path(forResource: "AHRefresh", ofType: "bundle")!)?.path(forResource: name, ofType: "png")
		return UIImage(contentsOfFile: path!)
	}
	
	// MARK: - subclass must override
	
	open func layoutHeaderForLoading() {
		fatalError("subclass must override")
	}
	
	open func layoutHeaderForStoped() {
		fatalError("subclass must override")
	}
	
	open func layoutHeaderForTriggered() {
		fatalError("subclass must override")
	}
	
	open func layoutHeaderForSuccess() {
		fatalError("subclass must override")
	}
	
	open func layoutHeaderForFailed() {
		fatalError("subclass must override")
	}
	
	open func layoutHeaderForNoMore() {
		fatalError("subclass must override")
	}
	
	// MARK: - subclass can override
	
	open func layoutHeaderForStoped(by contentOffset: CGFloat) {
		
	}
	
	open func timeIntervalForShowSuccessFailed() -> TimeInterval {
		return 3
	}
	
	open func timeIntervalForScrollAnimate() -> TimeInterval {
		return 0.25
	}
}
