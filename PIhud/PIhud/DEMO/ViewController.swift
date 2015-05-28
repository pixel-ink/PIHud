import UIKit

class ViewController: UIViewController {
  
  var pihud:PIHud!
  
  @IBAction func hud(sender: AnyObject) {
    pihud.hud( UIImage(named: "pict.png")!, text:"hello")
  }

  @IBAction func toast(sender: AnyObject) {
  }

  @IBAction func progress(sender: AnyObject) {
  }
  
  override func viewDidLoad() {
    pihud = PIHud(target:view)
    view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern.png")!)
    super.viewDidLoad()
  }

}

