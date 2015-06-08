
# PIHud
## HUD / Toast by swift

![](https://cocoapod-badges.herokuapp.com/l/PIHud/badge.png)
![](https://cocoapod-badges.herokuapp.com/v/PIHud/badge.png)
![](https://cocoapod-badges.herokuapp.com/p/PIHud/badge.png)

---

# install

- manually
  - add PIHud**.swift into your project
- cocoapods
  - add " pod 'PIHud', '0.1.3' " into your Podfile
  - add " import PIHud " into your code

# basic usage

- initialize
  - var pi = PIHud(target: yourUIView)
- toast
  - pi.toast("hello world")
- hud
  - pi.hud(UIImage(named: "pict.png")!, text:"hello")
- progress
  - pi.progressStart(UIImage(named: "pict.png")!, text:"hello")
  - pi.progressEnd()
