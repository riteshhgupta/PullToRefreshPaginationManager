//
//  PullToRefreshManager.swift
//  PullToRefreshPaginationManager
//
//  Created by Ritesh-Gupta on 17/04/16.
//  Copyright © 2016 Ritesh. All rights reserved.
//

import Foundation
import UIKit

public protocol PullToRefreshManagerDelegate: NSObjectProtocol {
	func refreshManagerDidStartLoading(controller: PullToRefreshManager, onCompletion: CompletionHandler)
}

public class PullToRefreshManager: NSObject {
	
	weak var delegate: PullToRefreshManagerDelegate?
	var scrollView: UIScrollView!
	var scrollViewStateController: ScrollViewStateController!
	var stateConfig: StateConfiguration!
	
	public init(scrollView: UIScrollView?, delegate: PullToRefreshManagerDelegate?, stateConfig: StateConfiguration = StateConfiguration(thresholdInitiateLoading: 0, loaderFrame: CGRectMake(0, -kDefaultLoaderHeight, UIScreen.mainScreen().bounds.size.width, kDefaultLoaderHeight), thresholdStartLoading: -kDefaultLoaderHeight)) {
		
		super.init()
		
		self.scrollView = scrollView
		self.delegate = delegate
		self.stateConfig = stateConfig
		self.scrollViewStateController = ScrollViewStateController(scrollView: scrollView, dataSource: self, delegate: self, showDefaultLoader: stateConfig.showDefaultLoader)
	}
	
	convenience override init() {
		self.init(scrollView: nil, delegate: nil)
	}
	
	public func updateActivityIndicatorStyle(newStyle: UIActivityIndicatorViewStyle) {
		self.scrollViewStateController.updateActivityIndicatorStyle(newStyle)
	}
	
	public func updateActivityIndicatorColor(color: UIColor) {
		self.scrollViewStateController.updateActivityIndicatorColor(color)
	}
	
}

extension PullToRefreshManager: ScrollViewStateControllerDataSource {
	
	public func stateControllerShouldInitiateLoading(offset: CGFloat) -> Bool {
		return offset < self.stateConfig.thresholdInitiateLoading
	}
	
	public func stateControllerDidReleaseToStartLoading(offset: CGFloat) -> Bool {
		return offset < self.stateConfig.thresholdStartLoading
	}
	
	public func stateControllerDidReleaseToCancelLoading(offset: CGFloat) -> Bool {
		return offset > self.stateConfig.thresholdStartLoading
	}
	
	public func stateControllerInsertLoaderInsets(startAnimation: Bool) -> UIEdgeInsets {
		var newInset = scrollView.contentInset
		newInset.top += startAnimation ? self.stateConfig.loaderFrame.size.height : -self.stateConfig.loaderFrame.size.height
		return newInset
	}
	
	public func stateControllerLoaderFrame() -> CGRect {
		return self.stateConfig.loaderFrame
	}
	
}

extension PullToRefreshManager: ScrollViewStateControllerDelegate {
	
	public func stateControllerDidStartLoading(controller: ScrollViewStateController, onCompletion: CompletionHandler) {
		self.delegate?.refreshManagerDidStartLoading(self, onCompletion: onCompletion)
	}
	
}
