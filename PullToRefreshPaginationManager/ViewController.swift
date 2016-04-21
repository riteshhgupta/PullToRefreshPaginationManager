//
//  ViewController.swift
//  PullToRefreshPaginationManager
//
//  Created by Ritesh-Gupta on 17/04/16.
//  Copyright © 2016 Ritesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var scrollView: UIScrollView!
	var refreshManager: PullToRefreshManager!
	var paginatioManager: PaginationManager!
	var horizontalPaginationManager: HorizontalPaginationManager!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		/* If you want to use Pull To Refresh */
		self.refreshManager = PullToRefreshManager(scrollView: self.scrollView, delegate: self)
		self.refreshManager.updateActivityIndicatorStyle(.WhiteLarge)
		self.refreshManager.updateActivityIndicatorColor(UIColor.blueColor())
		
		/* If you want to use Pagination */
		self.paginatioManager = PaginationManager(scrollView: self.scrollView, delegate: self)
		self.paginatioManager.updateActivityIndicatorColor(UIColor.redColor())
		
		/* If you want to use Horizontal Pagination */
		self.horizontalPaginationManager = HorizontalPaginationManager(scrollView: self.scrollView, delegate: self)
		self.horizontalPaginationManager.updateActivityIndicatorColor(UIColor.purpleColor())
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension ViewController: PullToRefreshManagerDelegate {
	
	func pullToRefreshManagerDidStartLoading(controller: PullToRefreshManager, onCompletion: CompletionHandler) {
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
			onCompletion()
		}
	}
	
}

extension ViewController: PaginationManagerDelegate {
	func paginationManagerDidStartLoading(controller: PaginationManager, onCompletion: CompletionHandler) {
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
			onCompletion()
		}
	}
	
	func paginationManagerShouldStartLoading(controller: PaginationManager) -> Bool {
		return true
	}
}

extension ViewController: HorizontalPaginationManagerDelegate {
	
	func horizontalPaginationManagerDidStartLoading(controller: HorizontalPaginationManager, onCompletion: CompletionHandler) {
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
		dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
			onCompletion()
		}
	}
	
}
