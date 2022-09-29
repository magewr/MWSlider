# MWSlider

![](https://github.com/magewr/MWSlider/blob/master/demo.gif)

A simple and intuitive slider with image, Lottie or gradation.
## Sample Code

### Image Type

```Swift
var imageSlider = MWSlider()
imageSlider.setTitle(title: "image Slider")
imageSlider.setImage(src: imageUrlString or imageNameString)
imageSlider.maximumValue = 100
imageSlider.value = 50
self.view.addSubview(imageSlider)
```

### Lottie Type
```Swift
var lottieSlider = MWSlider()
lottieSlider.setTitle(title: "lottie Slider")
lottieSlider.setLottieImage(src: lottieUrlString or lottieNameString)
lottieSlider.maximumValue = 500
lottieSlider.value = 350
self.view.addSubview(lottieSlider)
```

### Gradation Type
```Swift
var gradationSlider = MWSlider()
gradationSlider.setTitle(title: "gradation Slider")
gradationSlider.setGradient(colors: [UIColor(hex: 0x38D790).cgColor, UIColor(hex: 0x4A79F1).cgColor])
gradationSlider.maximumValue = 10
gradationSlider.value = 7
self.view.addSubview(gradationSlider)
```

If you need more code, see [DemoViewController](https://github.com/magewr/MWSlider/blob/master/MWSlider/DemoViewController.swift)

## Customizable properties
```Swift
class MWSlider: UISlider {
  var height: CGFloat = 56
  var cornerRadius: CGFloat = 12
  var borderWidth: CGFloat = 1.0
  var borderColor = UIColor.init(white: 1.0, alpha: 0.1).cgColor
}
```
, UISlider's properties.

If you want to make more properties or customize somethings, do fork or copy the code, and change everything. It's OK.

<hr>

used sample image : https://thumbs.dreamstime.com/b/empty-straight-road-top-aerial-view-highway-marking-seamless-roadway-horizontal-template-isolated-white-background-233113314.jpg

used sample Lottie file : https://assets2.lottiefiles.com/packages/lf20_fs64xxd6.json
