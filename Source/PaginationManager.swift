//
//  PaginationManager.swift
//  PullToRefreshPaginationManager
//
//  Created by Ritesh-Gupta on 17/04/16.
//  Copyright © 2016 Ritesh. All rights reserved.
//

import Foundation
import UIKit

public protocol PaginationManagerDelegate: NSObjectProtocol {
	
	func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool
	func paginationManagerDidStartLoading(_ controller: PaginationManager, onCompletion: @escaping CompletionHandler)
}

open class PaginationManager: NSObject {
	
	weak var delegate: PaginationManagerDelegate?
	var scrollView: UIScrollView!
	var scrollViewStateController: ScrollViewStateController!
	var stateConfig: StateConfiguration!
	
	public init(scrollView: UIScrollView?, delegate: PaginationManagerDelegate?, stateConfig: StateConfiguration = StateConfiguration(thresholdInitiateLoading: 0, loaderFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: kDefaultLoaderHeight), thresholdStartLoading: kDefaultLoaderHeight)) {
		
		super.init()
		
		self.scrollView = scrollView
		self.delegate = delegate
		self.stateConfig = stateConfig
		self.scrollViewStateController = ScrollViewStateController(scrollView: scrollView, dataSource: self, delegate: self, showDefaultLoader: stateConfig.showDefaultLoader)
	}
	
	convenience override init() {
		self.init(scrollView: nil, delegate: nil)
	}
	
	fileprivate func calculateDelta(_ offset: CGFloat) -> CGFloat {
		let calculatedOffset = max(0, scrollView.contentSize.height - scrollView.frame.size.height)
		let delta = offset - calculatedOffset
		return delta
	}
	
	open func updateActivityIndicatorStyle(_ newStyle: UIActivityIndicatorViewStyle) {
		self.scrollViewStateController.updateActivityIndicatorStyle(newStyle)
	}
	
	open func updateActivityIndicatorColor(_ color: UIColor) {
		self.scrollViewStateController.updateActivityIndicatorColor(color)
	}
	
}

extension PaginationManager: ScrollViewStateControllerDataSource {
	
	public func stateControllerShouldInitiateLoading(_ offset: CGFloat) -> Bool {
		let shouldStart = self.calculateDelta(offset) > self.stateConfig.thresholdInitiateLoading
		return shouldStart
	}
	
	public func stateControllerDidReleaseToStartLoading(_ offset: CGFloat) -> Bool {
		let shouldStart = self.calculateDelta(offset) > self.stateConfig.thresholdStartLoading
		return shouldStart
	}
	
	public func stateControllerDidReleaseToCancelLoading(_ offset: CGFloat) -> Bool {
		let shouldStart = self.calculateDelta(offset) < self.stateConfig.thresholdStartLoading
		return shouldStart
	}
	
	public func stateControllerInsertLoaderInsets(_ startAnimation: Bool) -> UIEdgeInsets {
		var newInset = scrollView?.contentInset
		newInset?.bottom += startAnimation ? self.stateConfig.loaderFrame.size.height : -self.stateConfig.loaderFrame.size.height
		return newInset!
	}
	
	public func stateControllerLoaderFrame() -> CGRect {
		var frame = self.stateConfig.loaderFrame
		frame.origin.y = self.scrollView.contentSize.height
		self.stateConfig.loaderFrame = frame
		return frame
	}
 
}

extension PaginationManager: ScrollViewStateControllerDelegate {
	
	public func stateControllerDidStartLoading(_ controller: ScrollViewStateController, onCompletion: @escaping CompletionHandler) {
		self.delegate?.paginationManagerDidStartLoading(self, onCompletion: onCompletion)
	}
	
	public func stateControllerShouldStartLoading(_ controller: ScrollViewStateController) -> Bool {
		return self.delegate?.paginationManagerShouldStartLoading(self) ?? true
	}
	
}
