//
//  PIHud.swift
//  PIhud
//
//  Created by yoshiki on 2015/04/30.
//  Copyright (c) 2015 pixel-ink. All rights reserved.
//

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
  
  init(target:UIView) {
    self.target = target
    hud = UIImageView()
    hud.alpha = 0.0
    hud.layer.cornerRadius = PIHudConfig.shared.cornerRadius
    target.addSubview(hud)
  }
  
  func hud(pict:UIImage, text:NSString) {
    hud.frame = PIHudImage.center(PIHudConfig.shared.hudSize, bound: target.size)
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
  
}
