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
	
	func rotateArrow(_ degrees: CGFloat, animated: Bool) {
		let transform = CATransform3DMakeRotation(degrees, 0, 0, 1)
		if animated {
			UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
				self.arrowImageView.layer.transform = transform
				}, completion: nil)
		} else {
			arrowImageView.layer.transform = transform
		}
	}
	
	override func layoutHeaderForStoped() {
		titleLabel.text = localizedString("AHRefreshStateStopedText")//"Pull to Refresh"
		arrowImageView.isHidden = false
		loadingActivity.isHidden = true
		loadingActivity.stopAnimating()
		if !enableGradient {
			rotateArrow(0, animated: true)
		}
	}
	
	override func layoutHeaderForStoped(by contentOffset: CGFloat) {
		let threshold = self.frame.origin.y - self.getOriginalInsetTop()
		var progress = 1 - (contentOffset - threshold) / self.bounds.size.height
		if 0 > progress {
			progress = 0
		} else if 1 < progress {
			progress = 1
		}
		rotateArrow(progress * .pi, animated: false)
	}
	
	override func layoutHeaderForTriggered() {
		titleLabel.text = localizedString("AHRefreshStateTriggeredText")//"Release to Refresh"
		arrowImageView.isHidden = false
		loadingActivity.isHidden = true
		if !enableGradient {
			rotateArrow(.pi, animated: true)
		}
	}
	
	override func layoutHeaderForLoading() {
		titleLabel.text = localizedString("AHRefreshStateLoadingText")//"Loading..."
		arrowImageView.isHidden = true
		loadingActivity.isHidden = false
		loadingActivity.startAnimating()
		if !enableGradient {
			rotateArrow(0, animated: true)
		}
	}
	
	lazy var titleLabel: UILabel = {
		var label = UILabel()
		label.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 22)
		label.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
		label.textColor = UIColor.black
		label.textAlignment = .center
		return label
	}()
	
	lazy var arrowImageView: UIImageView = {
		var imageView = UIImageView()
		if let arrowImage = self.arrowImage() {
			imageView.frame = CGRect(x: 0, y: 0, width: arrowImage.size.width, height: arrowImage.size.height)
			imageView.center = CGPoint(x: 30, y: self.bounds.midY)
			imageView.image = arrowImage
		}
		return imageView
	}()
	
	lazy var loadingActivity: UIActivityIndicatorView = {
		var activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
		activity.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		activity.center = CGPoint(x: 30, y: self.bounds.midY)
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
