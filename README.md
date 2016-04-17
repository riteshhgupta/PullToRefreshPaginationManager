#PullToRefreshPaginationManager
##About

PullToRefreshPaginationManager allows you to have **Refresh** (pull-to-refresh) & **Pagination** (load-more) functionality with just few lines of code. It can used with ```UIScrollView``` or its subclasses like ```UITableView``` & ```UICollectionView```. There are 2 ways of using it:

#### Default (quick plug-n-play support)

It provides default refresh & pagination-managers (vertical & horizontal) which allows you to have a quick plug-n-play support to handle your network calls. This can also be used to support complex refresh or pagination UI animations.

```
let refreshManager = PullToRefreshManager(scrollView: self.scrollView, delegate: self)

let paginatioManager = PaginationManager(scrollView: self.scrollView, delegate: self)

let horizontalPaginationManager = HorizontalPaginationManager(scrollView: self.scrollView, delegate: self)

```


#### Custom

Abitlity to quickly write your own custom refresh & pagination-manager by simply defining the ```ScrollViewStateControllerDataSource``` methods to defines their custom functionality. To know more about this you can checkout how I have made the default managers.


##Installation

To integrate PullToRefreshPaginationManager into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'PullToRefreshPaginationManager', :git => 'https://github.com/riteshhgupta/PullToRefreshPaginationManager.git', :branch => 'master'
```


##Detail-Usage

There are 2 ways of using it:

###Default Managers
Default managers allows to have the following functionalities with few lines of code and they provide their delegate methods to make the api call or animate your custom loader.

- PullToRefreshManager

```
let refreshManager = PullToRefreshManager(scrollView: self.scrollView, delegate: self)

// delegate method
func refreshManagerDidStartLoading(controller: PullToRefreshManager, onCompletion: CompletionHandler)

```

- PaginationManager

```
let paginatioManager = PaginationManager(scrollView: self.scrollView, delegate: self)

// delegate method
func paginationManagerDidStartLoading(controller: PaginationManager, onCompletion: CompletionHandler)
func paginationManagerShouldStartLoading(controller: PaginationManager) -> Bool
```

- HorizontalPaginationManager

```
let horizontalPaginationManager = HorizontalPaginationManager(scrollView: self.scrollView, delegate: self)

// delegate method
func horizontalPaginationManagerDidStartLoading(controller: HorizontalPaginationManager, onCompletion: CompletionHandler)
```

###Custom Manager

Other than the default managers if you feel you need more customizations then you can directly implement the following ```ScrollViewStateControllerDataSource``` methods to define your various custom conditions in your controller or inside any manager class:


```
  // it defines the condition whether to use y or x point for content offset
  func stateControllerWillObserveVerticalScrolling() -> Bool
  
  // it defines the condition when to enter the loading zone
  func stateControllerShouldInitiateLoading(offset: CGFloat) -> Bool
  
  // it defines the condition when the loader stablises (after releasing) and loading can start
  func stateControllerDidReleaseToStartLoading(offset: CGFloat) -> Bool
  
  // it defines the condition when to cancel loading
  func stateControllerDidReleaseToCancelLoading(offset: CGFloat) -> Bool
  
  // it will return the loader frame
  func stateControllerLoaderFrame() -> CGRect
  
  // it will return the loader inset
  func stateControllerInsertLoaderInsets(startAnimation: Bool) -> UIEdgeInsets
```

It provide following ```ScrollViewStateControllerDelegate``` methods to handle your api calls & custom loader animations.

```
// it gets called continously till your loading starts 
func stateControllerWillStartLoading(controller: ScrollViewStateController, loadingView: UIActivityIndicatorView)

// it allows you to decide if you want loading action 
func stateControllerShouldStartLoading(controller: ScrollViewStateController) -> Bool

// it gets called once when loading actually starts
func stateControllerDidStartLoading(controller: ScrollViewStateController, onCompletion: CompletionHandler)

//it gets called when loading is finished
func stateControllerDidFinishLoading(controller: ScrollViewStateController)
```


## Contributing

Open an issue or send pull request [here](https://github.com/riteshhgupta/PullToRefreshPaginationManager/issues/new).
