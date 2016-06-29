Pod::Spec.new do |s|
  s.name             = "UPCarouselFlowLayout"
  s.version          = "1.0.0"
  s.summary          = "A fancy carousel flow layout for UICollectionView."
  s.description      = "UPCarouselFlowLayout is a fancy carousel flow layout for UICollectionView. It comes with a paginated effect and it shrinks and makes transparent the side items."

  s.homepage         = "https://github.com/ink-spot/UPCarouselFlowLayout"
  # s.screenshots     = "https://github.com/ink-spot/UPCarouselFlowLayout/raw/master/images/demo.gif"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paul Ulric' => 'ink.and.spot@gmail.com' }
  s.source           = { :git => 'https://github.com/ink-spot/UPCarouselFlowLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.1'

  s.source_files = 'UPCarouselFlowLayout/**/*'

end
