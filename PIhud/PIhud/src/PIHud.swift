// https://github.com/pixel-ink/PIhud

import UIKit

class PIHudConfig {
  
  var speed = 0.3
  var delay = 1.5
  var cornerRadius = CGFloat(15.0)
  var backgroundColor = UIColor(white: 1.0, alpha: 0.6)
  var tintColor = UIColor(white: 0.0, alpha: 0.6)
  var hudSize = CGSize(width: 100, height: 100)
  var font = UIFont.boldSystemFontOfSize(20)
  private var fontHight = CGFloat(20.0)
  
  class var shared: PIHudConfig {
    struct Static {
      static let instance: PIHudConfig = PIHudConfig()
    }
    return Static.instance
  }
  
}



class PIHud {
  
  private let target:UIView
  private let hud:UIView
  private let hudIcon:UIImageView
  private let hudMessage:UILabel
  private let toast:UILabel
  
  init(target:UIView) {
    self.target = target
    
    hud = UIView()
    hud.alpha = 0.0
    target.addSubview(hud)
    
    hudIcon = UIImageView()
    hudIcon.contentMode = .ScaleAspectFit
    hud.addSubview(hudIcon)
    
    hudMessage = UILabel()
    hudMessage.textAlignment = .Center
    hudMessage.font = PIHudConfig.shared.font
    hudMessage.textColor = PIHudConfig.shared.tintColor
    hud.addSubview(hudMessage)
    
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
  
//  func progressStart(pict:UIImage, text:String) {
//    let op = progressStartOperation(pict, text: text)
//    PIHudQueue.hud.add(op)
//  }
//  
//  func progressEnd() {
//    let op = progressEndOperation()
//    PIHudQueue.hud.add(op)
//  }

  private func hudLayout(withMessage:Bool) {
    let size = PIHudConfig.shared.hudSize
    if withMessage {
      let fh = PIHudConfig.shared.fontHight
      hudMessage.hidden = false
      hudIcon.frame.size = CGSizeMake(size.w,size.h - fh)
      hudIcon.frame.origin = CGPointZero
      hudMessage.frame.size = CGSizeMake(size.w,fh)
      hudMessage.frame.origin = CGPointMake(0,size.h-fh)
    } else {
      hudMessage.hidden = true
      hudIcon.frame.size = size
      hudIcon.frame.origin = CGPointZero
    }
  }
  
  func hudOperation(pict:UIImage, text:String ) -> ( (final:()->()) -> () ) {
    return {
      [weak self] final in
      if let s = self {
        s.hud.frame = PIHudImage.center(PIHudConfig.shared.hudSize, bound: s.target.size ?? CGSizeZero)
        s.hud.backgroundColor = PIHudConfig.shared.backgroundColor
        s.hud.layer.cornerRadius = PIHudConfig.shared.cornerRadius
        s.hudIcon.image = pict
        s.hudMessage.text = text
        s.hudLayout(true)
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
  
//  func progressStartOperation(pict:UIImage, text:String ) -> ( (final:()->()) -> () ) {
//    return {
//      [weak self] final in
//      if let s = self {
//        s.hud.frame = PIHudImage.center(PIHudConfig.shared.hudSize, bound: s.target.size ?? CGSizeZero)
//        s.hud.backgroundColor = PIHudConfig.shared.backgroundColor
//        s.hud.image = PIHudImage.hudImage(pict, text: text)
//        s.hud.layer.cornerRadius = PIHudConfig.shared.cornerRadius
//        PIHudAnime.start({
//          s.hud.alpha = 1.0
//          }){final()}
//      } else {
//        final()
//      }
//    }
//  }
//
//  func progressEndOperation() -> ( (final:()->()) -> () ) {
//    return {
//      [weak self] final in
//      if let s = self {
//        PIHudAnime.start({
//          s.hud.alpha = 0.0
//          }){final()}
//      } else {
//        final()
//      }
//    }
//  }
  
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
