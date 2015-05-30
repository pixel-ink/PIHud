// https://github.com/pixel-ink/PIhud

import UIKit

class PIHudConfig {
  
  var speed = 0.3
  var delay = 1.5
  var cornerRadius: CGFloat = 15.0
  var backgroundColor = UIColor(white: 1.0, alpha: 0.6)
  var tintColor = UIColor(white: 0.0, alpha: 0.6)
  var hudSize = CGSize(width: 100, height: 100)
  var font = UIFont.boldSystemFontOfSize(20)
  
  class var shared: PIHudConfig {
    struct Static {
      static let instance: PIHudConfig = PIHudConfig()
    }
    return Static.instance
  }
  
}



class PIHud {
  
  let target:UIView
  let hud:UIImageView
  let toast:UILabel
  
  init(target:UIView) {
    self.target = target
    
    hud = UIImageView()
    hud.alpha = 0.0
    target.addSubview(hud)
    
    toast = UILabel()
    toast.alpha = 0.0
    target.addSubview(toast)
    
  }
  
  func hud(pict:UIImage, text:String) {
    let op = hudOperation(pict, text: text)
    PIHudQueue.hud.add(op)
  }

  func toast(text:String) {
    let op = toastOperation(text)
    PIHudQueue.toast.add(op)
  }
  
  func hudOperation(pict:UIImage, text:String ) -> ( (final:()->()) -> () ) {
    return {
      [weak self] final in
      if let s = self {
        s.hud.frame = PIHudImage.center(PIHudConfig.shared.hudSize, bound: s.target.size ?? CGSizeZero)
        s.hud.backgroundColor = PIHudConfig.shared.backgroundColor
        s.hud.image = PIHudImage.hudImage(pict, text: text)
        s.hud.layer.cornerRadius = PIHudConfig.shared.cornerRadius
        PIHudAnime.start({
          s.hud.alpha = 1.0
          }){
            PIHudAnime.delay ({
              s.hud.alpha = 0.0
              }){final()}
        }
      } else {
        final()
      }
    }
  }
  
  func toastOperation(text:String) -> ( (final:()->()) -> () ) {
    return {
      [weak self] final in
      if let s = self {
        s.toast.backgroundColor = PIHudConfig.shared.backgroundColor
        s.toast.font = PIHudConfig.shared.font
        s.toast.text = text
        s.toast.sizeToFit()
        s.toast.textColor = PIHudConfig.shared.tintColor
        s.toast.textAlignment = .Center
        s.toast.frame.inset(dx: -10, dy: -10)
        s.toast.layer.cornerRadius = PIHudConfig.shared.cornerRadius
        s.toast.clipsToBounds = true
        s.toast.center = s.target.center
        s.toast.frame.origin.y = s.target.h - s.toast.h - 30.0
        PIHudAnime.start({
          s.toast.alpha = 1.0
          }){
            PIHudAnime.delay ({
              s.toast.alpha = 0.0
              }){final()}
        }
      } else {final()}
    }
  }
}
