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
    hud.frame = PIHudImage.center(PIHudConfig.shared.hudSize, bound: target.size)
    hud.backgroundColor = PIHudConfig.shared.backgroundColor
    hud.image = PIHudImage.hudImage(pict, text: text)
    hud.layer.cornerRadius = PIHudConfig.shared.cornerRadius
    PIHudAnime.start({
      [weak self] in
      self?.hud.alpha = 1.0
      }){
        PIHudAnime.delay ({
          [weak self] in
          self?.hud.alpha = 0.0
          })
    }
  }
 
  func toast(text:String) {
    toast.backgroundColor = PIHudConfig.shared.backgroundColor
    toast.font = PIHudConfig.shared.font
    toast.text = text
    toast.sizeToFit()
    toast.textColor = PIHudConfig.shared.tintColor
    toast.textAlignment = .Center
    toast.frame.inset(dx: -10, dy: -10)
    toast.layer.cornerRadius = PIHudConfig.shared.cornerRadius
    toast.clipsToBounds = true
    toast.center = target.center
    toast.frame.origin.y = target.h - toast.h - 30.0
    PIHudAnime.start({
      [weak self] in
      self?.toast.alpha = 1.0
      }){
        PIHudAnime.delay ({
          [weak self] in
          self?.toast.alpha = 0.0
          })
    }
  }

}
