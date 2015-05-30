// https://github.com/pixel-ink/PIhud

import Foundation

internal class PIHudQueue {
  
  private var queue : [ (final:()->()) -> () ] = []
  private var semaphore = dispatch_semaphore_create(1)
  
  func add(operation: (final:()->()) -> () ) {
    queue.append(operation)
    step()
  }
  
  func step() {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
      dispatch_semaphore_wait(self.semaphore,DISPATCH_TIME_FOREVER)
      dispatch_async(dispatch_get_main_queue()){
        if self.queue.count > 0 {
          let op = self.queue[0]
          let a = self.queue.removeAtIndex(0)
          op(){
            dispatch_semaphore_signal(self.semaphore)
            self.step()
          }
        } else {
          dispatch_semaphore_signal(self.semaphore)
        }
      }
    }
  }
  
  class var hud: PIHudQueue {
    struct Static {
      static let instance: PIHudQueue = PIHudQueue()
    }
    return Static.instance
  }
  
  class var toast: PIHudQueue {
    struct Static {
      static let instance: PIHudQueue = PIHudQueue()
    }
    return Static.instance
  }
  
}
