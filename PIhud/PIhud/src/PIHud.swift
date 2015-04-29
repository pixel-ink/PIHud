//
//  PIHud.swift
//  PIhud
//
//  Created by yoshiki on 2015/04/30.
//  Copyright (c) 2015 pixel-ink. All rights reserved.
//

import UIKit

private extension UIView {
  var x: CGFloat { return self.frame.origin.x }
  var y: CGFloat { return self.frame.origin.y }
  var w: CGFloat { return self.frame.size.width }
  var h: CGFloat { return self.frame.size.height }
}

private extension CGRect {
  var x: CGFloat { return self.origin.x }
  var y: CGFloat { return self.origin.y }
  var w: CGFloat { return self.size.width }
  var h: CGFloat { return self.size.height }
}

private extension CGSize {
  var w: CGFloat { return self.width }
  var h: CGFloat { return self.height }
}

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

private class PIHudAnime {
  
  private class func anime(delay:Bool, animations:() -> Void, completion:() -> Void) {
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

private class PIHudImage {
  
  private class func center(aspect:CGSize, bound:CGSize) -> CGRect {
    let x = (bound.w - aspect.w) / 2
    let y = (bound.h - aspect.h) / 2
    return CGRectMake(x, y, aspect.w, aspect.h)
  }
  
  private class func aspectFit(aspect:CGSize, bound:CGSize) -> CGRect {
    let scale = min(bound.w / aspect.w, bound.h / aspect.h)
    let size = CGSizeMake(aspect.w * scale, aspect.h * scale)
    return center(size, bound:bound)
  }
  
  private class func aspectFill(aspect:CGSize, bound:CGSize) -> CGRect {
    let w = bound.w / aspect.w
    let h = bound.h / aspect.h
    var out = bound
    if( h > w ){
      out.width = bound.h / aspect.h * aspect.w
    }else if( w > h ){
      out.height = bound.w / aspect.w * aspect.h
    }
    return center(out, bound: bound)
  }
  
  class func hudImage(pict:UIImage, text:NSString) -> UIImage {
    let size = PIHudConfig.shared.hudSize
    let attr = [
      NSFontAttributeName: PIHudConfig.shared.font,
      NSForegroundColorAttributeName: PIHudConfig.shared.tintColor
    ]
    let padding = PIHudConfig.shared.cornerRadius
    
    UIGraphicsBeginImageContext(PIHudConfig.shared.hudSize)
    pict.drawInRect(aspectFill(pict.size, bound:CGSizeMake(size.w, size.h * 3 / 4)))
    text.drawInRect(CGRectMake(padding, size.h * 3 / 4, size.w - padding * 2, size.h / 4), withAttributes: attr)
    let out = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext()
    return out
  }
}

class PIHud {
  
  let target:UIView
  let hud:UIImageView
  
  init(target:UIView) {
    self.target = target
    hud = UIImageView()
    hud.alpha = 0.0
    hud.layer.cornerRadius = PIHudConfig.shared.cornerRadius
    target.addSubview(hud)
  }
  
  func hud(pict:UIImage, text:NSString) {
    hud.frame = center(PIHudConfig.shared.hudSize)
    hud.backgroundColor = PIHudConfig.shared.backgroundColor
    hud.image = PIHudImage.hudImage(pict, text: text)
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
  
  private func center(size:CGSize) -> CGRect {
    return CGRectMake((target.w - size.w) / 2, (target.h - size.h) / 2, size.w, size.h)
  }
  
}