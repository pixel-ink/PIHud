//
//  PIHud.swift
//  PIhud
//
//  Created by yoshiki on 2015/04/30.
//  Copyright (c) 2015 pixel-ink. All rights reserved.
//

import UIKit

internal class PIHudImage {
  
  class func center(aspect:CGSize, bound:CGSize) -> CGRect {
    let x = (bound.w - aspect.w) / 2
    let y = (bound.h - aspect.h) / 2
    return CGRectMake(x, y, aspect.w, aspect.h)
  }
  
  class func aspectFit(aspect:CGSize, bound:CGSize) -> CGRect {
    let scale = min(bound.w / aspect.w, bound.h / aspect.h)
    let size = CGSizeMake(aspect.w * scale, aspect.h * scale)
    return center(size, bound:bound)
  }
  
  class func aspectFill(aspect:CGSize, bound:CGSize) -> CGRect {
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
  
  class func aspectFit(aspect:CGSize, bound:CGRect) -> CGRect {
    let s = PIHudImage.aspectFit(aspect, bound: bound.size)
    return CGRectMake(bound.x / 2 + s.x, bound.y / 2 + s.y, s.w, s.h)
  }
  
  class func aspectFill(aspect:CGSize, bound:CGRect) -> CGRect {
    let s = PIHudImage.aspectFill(aspect, bound: bound.size)
    return CGRectMake(bound.x / 2 + s.x, bound.y / 2 + s.y, s.w, s.h)
  }

  class func hudImage(pict:UIImage, text:NSString) -> UIImage {
    let size = PIHudConfig.shared.hudSize
    let attr = [
      NSFontAttributeName: PIHudConfig.shared.font,
      NSForegroundColorAttributeName: PIHudConfig.shared.tintColor
    ]
    let padding = PIHudConfig.shared.cornerRadius
    let fontHeight = text.sizeWithAttributes(attr).h
    UIGraphicsBeginImageContext(PIHudConfig.shared.hudSize)
    pict.drawInRect(aspectFit(pict.size, bound:CGRectMake(padding, padding, size.w - padding, size.h - fontHeight - padding)))
    text.drawInRect(CGRectMake(padding, size.h - fontHeight - padding, size.w - padding, fontHeight), withAttributes: attr)
    let out = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext()
    return out
  }
}
