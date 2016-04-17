Pod::Spec.new do |spec|
  spec.name         =  'PullToRefreshPaginationManager'
  spec.version      =  '0.1'
  spec.summary   =  'It  allows you to have Refresh (pull-to-refresh) & Pagination (load-more) functionality with just few lines of code.'
  spec.author = {
    'Ritesh Gupta' => 'rg.riteshh@gmail.com'
  }
  spec.license          =  'MIT' 
  spec.homepage         =  'https://github.com/riteshhgupta/PullToRefreshPaginationManager'
  spec.source = {
    :git => 'https://github.com/riteshhgupta/PullToRefreshPaginationManager.git',
    :tag => '0.1'
  }
  spec.ios.deployment_target = "8.0"
  spec.source_files =  'Source/*.{swift}'
  spec.requires_arc     =  true
end