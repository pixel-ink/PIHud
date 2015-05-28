// https://github.com/pixel-ink/PIhud

import UIKit

internal class PIHudAnime {
  
  internal class func anime(delay:Bool, animations:() -> Void, completion:() -> Void) {
    UIView.animateWithDuration(
      PIHudConfig.shared.speed,
      delay: delay ? PIHudConfig.shared.delay : 0.0,
      options: UIViewAnimationOptions.CurveEaseIn,
      animations: animations,
      completion: {
        (fin:Bool) -> Void in
        completion()
      }
    )
  }
  
  class func start(animations:()->Void) {
    PIHudAnime.anime(false, animations: animations, completion: {})
  }
  
  class func start(animations:()->Void, completion:() -> Void) {
    PIHudAnime.anime(false, animations: animations, completion: completion)
  }
  
  class func delay(animations:()->Void) {
    PIHudAnime.anime(true, animations: animations, completion: {})
  }
  
  class func delay(animations:()->Void, completion:() -> Void) {
    PIHudAnime.anime(true, animations: animations, completion: completion)
  }
  
}
