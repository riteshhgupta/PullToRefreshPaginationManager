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
	
	func pullToRefreshManagerDidStartLoading(_ controller: PullToRefreshManager, onCompletion: @escaping CompletionHandler)
}

open class PullToRefreshManager: NSObject {
	
	weak var delegate: PullToRefreshManagerDelegate?
	var scrollView: UIScrollView!
	var scrollViewStateController: ScrollViewStateController!
	var stateConfig: StateConfiguration!
	
	public init(scrollView: UIScrollView?, delegate: PullToRefreshManagerDelegate?, stateConfig: StateConfiguration = StateConfiguration(thresholdInitiateLoading: 0, loaderFrame: CGRect(x: 0, y: -kDefaultLoaderHeight, width: UIScreen.main.bounds.size.width, height: kDefaultLoaderHeight), thresholdStartLoading: -kDefaultLoaderHeight)) {
		
		super.init()
		
		self.scrollView = scrollView
		self.delegate = delegate
		self.stateConfig = stateConfig
		self.scrollViewStateController = ScrollViewStateController(scrollView: scrollView, dataSource: self, delegate: self, showDefaultLoader: stateConfig.showDefaultLoader)
	}
	
	convenience override init() {
		self.init(scrollView: nil, delegate: nil)
	}
	
	open func updateActivityIndicatorStyle(_ newStyle: UIActivityIndicatorViewStyle) {
		self.scrollViewStateController.updateActivityIndicatorStyle(newStyle)
	}
	
	open func updateActivityIndicatorColor(_ color: UIColor) {
		self.scrollViewStateController.updateActivityIndicatorColor(color)
	}
	
	open func deactivate() {
		scrollViewStateController.loadingView.removeFromSuperview()
		scrollViewStateController.delegate = nil
		scrollViewStateController.dataSource = nil
	}
}

extension PullToRefreshManager: ScrollViewStateControllerDataSource {
	
	public func stateControllerShouldInitiateLoading(_ offset: CGFloat) -> Bool {
		return offset < self.stateConfig.thresholdInitiateLoading
	}
	
	public func stateControllerDidReleaseToStartLoading(_ offset: CGFloat) -> Bool {
		return offset < self.stateConfig.thresholdStartLoading
	}
	
	public func stateControllerDidReleaseToCancelLoading(_ offset: CGFloat) -> Bool {
		return offset > self.stateConfig.thresholdStartLoading
	}
	
	public func stateControllerInsertLoaderInsets(_ startAnimation: Bool) -> UIEdgeInsets {
		var newInset = scrollView.contentInset
		newInset.top += startAnimation ? self.stateConfig.loaderFrame.size.height : -self.stateConfig.loaderFrame.size.height
		return newInset
	}
	
	public func stateControllerLoaderFrame() -> CGRect {
		return self.stateConfig.loaderFrame
	}
	
}

extension PullToRefreshManager: ScrollViewStateControllerDelegate {
	
	public func stateControllerDidStartLoading(_ controller: ScrollViewStateController, onCompletion: @escaping CompletionHandler) {
		self.delegate?.pullToRefreshManagerDidStartLoading(self, onCompletion: onCompletion)
	}
	
}
