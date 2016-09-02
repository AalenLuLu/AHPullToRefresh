//
//  AHRefreshTextHeader.swift
//  AHPullToRefreshDemo
//
//  Created by Aalen on 16/9/1.
//  Copyright © 2016年 Aalen. All rights reserved.
//

import UIKit

class AHRefreshTextHeader: AHRefreshHeader {
	
	required init(frame: CGRect) {
		super.init(frame: frame)
		self.addSubview(titleLabel)
		self.addSubview(arrowImageView)
		self.addSubview(loadingActivity)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func rotateArrow(degrees: CGFloat, animated: Bool) {
		let transform = CATransform3DMakeRotation(degrees, 0, 0, 1)
		if animated {
			UIView.animateWithDuration(0.2, delay: 0, options: .BeginFromCurrentState, animations: {
				self.arrowImageView.layer.transform = transform
				}, completion: nil)
		} else {
			arrowImageView.layer.transform = transform
		}
	}
	
	override func layoutHeaderForStoped() {
		titleLabel.text = localizedString("AHRefreshStateStopedText")//"Pull to Refresh"
		arrowImageView.hidden = false
		loadingActivity.hidden = true
		loadingActivity.stopAnimating()
//		rotateArrow(0, animated: false)
	}
	
	override func layoutHeaderForStoped(by contentOffset: CGFloat) {
		let threshold = self.frame.origin.y - self.getOriginalInsetTop()
		var progress = 1 - (contentOffset - threshold) / self.bounds.size.height
		if 0 > progress {
			progress = 0
		} else if 1 < progress {
			progress = 1
		}
		rotateArrow(progress * CGFloat(M_PI), animated: false)
	}
	
	override func layoutHeaderForTriggered() {
		titleLabel.text = localizedString("AHRefreshStateTriggeredText")//"Release to Refresh"
		arrowImageView.hidden = false
		loadingActivity.hidden = true
//		rotateArrow(CGFloat(M_PI), animated: false)
	}
	
	override func layoutHeaderForLoading() {
		titleLabel.text = localizedString("AHRefreshStateLoadingText")//"Loading..."
		arrowImageView.hidden = true
		loadingActivity.hidden = false
		loadingActivity.startAnimating()
//		rotateArrow(0, animated: false)
	}
	
	lazy var titleLabel: UILabel = {
		var label = UILabel()
		label.frame = CGRectMake(0, 0, self.bounds.size.width, 22)
		label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
		label.textColor = UIColor.blackColor()
		label.textAlignment = .Center
		return label
	}()
	
	lazy var arrowImageView: UIImageView = {
		var imageView = UIImageView()
		if let arrowImage = self.arrowImage() {
			imageView.frame = CGRectMake(0, 0, arrowImage.size.width, arrowImage.size.height)
			imageView.center = CGPointMake(30, CGRectGetMidY(self.bounds))
			imageView.image = arrowImage
		}
		return imageView
	}()
	
	lazy var loadingActivity: UIActivityIndicatorView = {
		var activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
		activity.frame = CGRectMake(0, 0, 40, 40)
		activity.center = CGPointMake(30, CGRectGetMidY(self.bounds))
		return activity
	}()
	
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
