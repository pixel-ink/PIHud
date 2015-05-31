import UIKit

class ViewController: UIViewController {
  
  var pihud:PIHud!
  
  @IBAction func hud(sender: AnyObject) {
    pihud.hud( UIImage(named: "pict.png")!, text:"hello")
  }

  @IBAction func toast(sender: AnyObject) {
    pihud.toast("hello world")
  }

  @IBAction func progress(sender: AnyObject) {
    pihud.progressStart( UIImage(named: "pict.png")!, text:"hello")
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
      [weak self] in
      if let s = self {
        sleep(5)
        s.pihud.progressEnd()
      }
    }
  }
  
  override func viewDidLoad() {
    pihud = PIHud(target:view)
    view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern.png")!)
    super.viewDidLoad()
  }

}

