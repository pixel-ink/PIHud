// https://github.com/pixel-ink/PIhud

import UIKit

internal extension UIView {
  var size: CGSize { return self.frame.size }
  var x: CGFloat { return self.frame.origin.x }
  var y: CGFloat { return self.frame.origin.y }
  var w: CGFloat { return self.frame.size.width }
  var h: CGFloat { return self.frame.size.height }
}

internal extension CGRect {
  var x: CGFloat { return self.origin.x }
  var y: CGFloat { return self.origin.y }
  var w: CGFloat { return self.size.width }
  var h: CGFloat { return self.size.height }
}

internal extension CGSize {
  var w: CGFloat { return self.width }
  var h: CGFloat { return self.height }
}
