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
	func paginationManagerShouldStartLoading(controller: PaginationManager) -> Bool
	func paginationManagerDidStartLoading(controller: PaginationManager, onCompletion: CompletionHandler)
}

public class PaginationManager: NSObject {
	
	weak var delegate: PaginationManagerDelegate?
	var scrollView: UIScrollView!
	var scrollViewStateController: ScrollViewStateController!
	var stateConfig: StateConfiguration!
	
	public init(scrollView: UIScrollView?, delegate: PaginationManagerDelegate?, stateConfig: StateConfiguration = StateConfiguration(thresholdInitiateLoading: 0, loaderFrame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, kDefaultLoaderHeight), thresholdStartLoading: kDefaultLoaderHeight)) {
		
		super.init()
		
		self.scrollView = scrollView
		self.delegate = delegate
		self.stateConfig = stateConfig
		self.scrollViewStateController = ScrollViewStateController(scrollView: scrollView, dataSource: self, delegate: self, showDefaultLoader: stateConfig.showDefaultLoader)
	}
	
	convenience override init() {
		self.init(scrollView: nil, delegate: nil)
	}
	
	private func calculateDelta(offset: CGFloat) -> CGFloat {
		let calculatedOffset = max(0, scrollView.contentSize.height - scrollView.frame.size.height)
		let delta = offset - calculatedOffset
		return delta
	}
	
	public func updateActivityIndicatorStyle(newStyle: UIActivityIndicatorViewStyle) {
		self.scrollViewStateController.updateActivityIndicatorStyle(newStyle)
	}
	
	public func updateActivityIndicatorColor(color: UIColor) {
		self.scrollViewStateController.updateActivityIndicatorColor(color)
	}
	
}

extension PaginationManager: ScrollViewStateControllerDataSource {
	
	public func stateControllerShouldInitiateLoading(offset: CGFloat) -> Bool {
		let shouldStart = self.calculateDelta(offset) > self.stateConfig.thresholdInitiateLoading
		return shouldStart
	}
	
	public func stateControllerDidReleaseToStartLoading(offset: CGFloat) -> Bool {
		let shouldStart = self.calculateDelta(offset) > self.stateConfig.thresholdStartLoading
		return shouldStart
	}
	
	public func stateControllerDidReleaseToCancelLoading(offset: CGFloat) -> Bool {
		let shouldStart = self.calculateDelta(offset) < self.stateConfig.thresholdStartLoading
		return shouldStart
	}
	
	public func stateControllerInsertLoaderInsets(startAnimation: Bool) -> UIEdgeInsets {
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
	
	public func stateControllerDidStartLoading(controller: ScrollViewStateController, onCompletion: CompletionHandler) {
		self.delegate?.paginationManagerDidStartLoading(self, onCompletion: onCompletion)
	}
	
	public func stateControllerShouldStartLoading(controller: ScrollViewStateController) -> Bool {
		return self.delegate?.paginationManagerShouldStartLoading(self) ?? true
	}
	
}
