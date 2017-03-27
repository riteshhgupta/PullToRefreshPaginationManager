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
		self.refreshManager.updateActivityIndicatorStyle(.whiteLarge)
		self.refreshManager.updateActivityIndicatorColor(UIColor.blue)
		
		/* If you want to use Pagination */
		self.paginatioManager = PaginationManager(scrollView: self.scrollView, delegate: self)
		self.paginatioManager.updateActivityIndicatorColor(UIColor.red)
		
		/* If you want to use Horizontal Pagination */
		self.horizontalPaginationManager = HorizontalPaginationManager(scrollView: self.scrollView, delegate: self)
		self.horizontalPaginationManager.updateActivityIndicatorColor(UIColor.purple)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension ViewController: PullToRefreshManagerDelegate {
	
	public func pullToRefreshManagerDidStartLoading(_ controller: PullToRefreshManager, onCompletion: @escaping () -> Void) {
		let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
			onCompletion()
		}
	}
}

extension ViewController: PaginationManagerDelegate {
	
	public func paginationManagerDidStartLoading(_ controller: PaginationManager, onCompletion: @escaping () -> Void) {
		let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
			onCompletion()
		}
	}
	
	public func paginationManagerShouldStartLoading(_ controller: PaginationManager) -> Bool {
		return true
	}
}

extension ViewController: HorizontalPaginationManagerDelegate {
	
	public func horizontalPaginationManagerDidStartLoading(_ controller: HorizontalPaginationManager, onCompletion: @escaping () -> Void) {
		let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
			onCompletion()
		}
	}
}
