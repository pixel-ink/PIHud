// https://github.com/pixel-ink/PIhud

import UIKit

class PIHud {

  struct Config {
    var speed = 0.3
    var delay = 1.5
    var cornerRadius = CGFloat(15.0)
    var backgroundColor = UIColor(white: 1.0, alpha: 0.6)
    var tintColor = UIColor(white: 0.0, alpha: 0.6)
    var hudSize = CGSize(width: 100, height: 100)
    var font = UIFont.boldSystemFontOfSize(20)
    private var fontHight = CGFloat(20.0)
  }
  
  private let config: Config
  private let target: UIView
  private let hud: UIView
  private let hudIcon: UIImageView
  private let hudMessage: UILabel
  private let toast: UILabel
  
  init(target:UIView) {
    self.target = target
    config = Config()
    
    hud = UIView()
    hud.alpha = 0.0
    target.addSubview(hud)
    
    hudIcon = UIImageView()
    hudIcon.contentMode = .ScaleAspectFit
    hud.addSubview(hudIcon)
    
    hudMessage = UILabel()
    hudMessage.textAlignment = .Center
    hudMessage.font = config.font
    hudMessage.textColor = config.tintColor
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
  
  func progressStart(pict:UIImage, text:String) {
    let op = progressStartOperation(pict, text: text)
    PIHudQueue.hud.add(op)
  }
  
  func progressEnd() {
    let op = progressEndOperation()
    PIHudQueue.hud.add(op)
  }

  private func hudLayout(withMessage:Bool) {
    let size = config.hudSize
    if withMessage {
      let fh = config.fontHight
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
        s.hud.frame.size = s.config.hudSize
        s.hud.center = s.target.center
        s.hud.backgroundColor = s.config.backgroundColor
        s.hud.layer.cornerRadius = s.config.cornerRadius
        s.hudIcon.image = pict
        s.hudMessage.text = text
        s.hudLayout(true)
        s.hudIcon.layer.removeAllAnimations()
        s.start({
          s.hud.alpha = 1.0
          }){
            s.delay ({
              s.hud.alpha = 0.0
              }){final()}
        }
      } else {
        final()
      }
    }
  }
  
  func progressStartOperation(pict:UIImage, text:String ) -> ( (final:()->()) -> () ) {
    return {
      [weak self] final in
      if let s = self {
        s.hud.frame.size = s.config.hudSize
        s.hud.center = s.target.center
        s.hud.backgroundColor = s.config.backgroundColor
        s.hud.layer.cornerRadius = s.config.cornerRadius
        s.hudIcon.image = pict
        s.hudMessage.text = text
        s.hudLayout(true)
        s.hudIcon.layer.addAnimation(s.spin(), forKey: "spin")
        s.start({
          s.hud.alpha = 1.0
          }){final()}
      } else {
        final()
      }
    }
  }

  func progressEndOperation() -> ( (final:()->()) -> () ) {
    return {
      [weak self] final in
      if let s = self {
        s.start({
          s.hud.alpha = 0.0
          }){
            s.hudIcon.layer.removeAllAnimations()
            final()
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
        s.toast.backgroundColor = s.config.backgroundColor
        s.toast.font = s.config.font
        s.toast.text = text
        s.toast.sizeToFit()
        s.toast.textColor = s.config.tintColor
        s.toast.textAlignment = .Center
        s.toast.frame.inset(dx: -10, dy: -10)
        s.toast.layer.cornerRadius = s.config.cornerRadius
        s.toast.clipsToBounds = true
        s.toast.center = s.target.center
        s.toast.frame.origin.y = s.target.h - s.toast.h - 30.0
        s.start({
          s.toast.alpha = 1.0
          }){
            s.delay ({
              s.toast.alpha = 0.0
              }){final()}
        }
      } else {final()}
    }
  }
  
  //animation
  
  func spin() -> CABasicAnimation {
    let spin = CABasicAnimation(keyPath: "transform.rotation")
    spin.repeatCount = MAXFLOAT
    spin.duration = 1.0
    spin.toValue = M_PI / 2.0
    spin.cumulative = true
    spin.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    return spin
  }
  
  func start(animations:()->Void, completion:() -> Void) {
    anime(false, animations: animations, completion: completion)
  }
  
  func delay(animations:()->Void, completion:() -> Void) {
    anime(true, animations: animations, completion: completion)
  }

  func anime(delay:Bool, animations:() -> Void, completion:() -> Void) {
    UIView.animateWithDuration(
      config.speed,
      delay: delay ? config.delay : 0.0,
      options: UIViewAnimationOptions.CurveEaseIn,
      animations: animations,
      completion: {
        (fin:Bool) -> Void in
        completion()
      }
    )
  }
  
}
