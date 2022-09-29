//
//  MWSlider.swift
//  MWSlider
//
//  Created by 최우람 on 2022/08/30.
//

import UIKit
import Lottie
import SnapKit
import SDWebImage
import RxSwift
import RxCocoa

class MWSlider: UISlider {
    private var type: BackgroundType = .none
    
    var lottieUrlString: String?
    var imageUrlString: String?
    var gradientColors: [CGColor]?
    var height: CGFloat = 56
    var cornerRadius: CGFloat = 12
    var borderWidth: CGFloat = 1.0
    var borderColor = UIColor.init(white: 1.0, alpha: 0.1).cgColor
    
    private var bgImage = UIImageView()
    private var bgLottieView = AnimationView()
    private var valueLabel = UILabel()
    private var titleLabel = UILabel()
    
    weak var slideTrackDelegate: SlideTrackDelegate?
    var slideTrackRelay = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func updateConstraints() {
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(self.height)
        }
        
        self.bgLottieView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(-2)
            make.leading.trailing.equalToSuperview().inset(-3)
        }
        
        self.bgImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(-2)
            make.leading.trailing.equalToSuperview().inset(-3)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        self.valueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    private func commonInit() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor
        self.clipsToBounds = true
        
        self.setThumbImage(UIImage(), for: .normal)
        self.setThumbImage(UIImage(), for: .highlighted)
        
        self.addSubview(bgImage)
        self.sendSubviewToBack(bgImage)
        self.addSubview(self.bgLottieView)
        self.sendSubviewToBack(self.bgLottieView)
        
        self.valueLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.valueLabel.textColor = .white
        self.valueLabel.textAlignment = .right
        self.valueLabel.sizeToFit()
        self.addSubview(self.valueLabel)
        
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .left
        
        self.addSubview(self.titleLabel)
        addTapGesture()
    }
    
    public func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        pan.cancelsTouchesInView = false
        addGestureRecognizer(tap)
        addGestureRecognizer(pan)
    }
    
    @objc private func handleTap(_ sender: UIGestureRecognizer) {
        let location = sender.location(in: self)
        let percent = minimumValue + Float(location.x / bounds.width) * maximumValue
        setValue(percent, animated: sender.isKind(of: UITapGestureRecognizer.self))
        sendActions(for: .valueChanged)
        if sender.state == .ended {
            self.slideTrackDelegate?.endSlideTracking()
            self.slideTrackRelay.accept(())
        }
    }
    
    func setLottieImage(src: String) {
        self.type = .lottie
        self.lottieUrlString = src
        self.imageUrlString = nil
    }
    
    func setImage(src: String) {
        self.type = .image
        self.imageUrlString = src
        self.lottieUrlString = nil
    }
    
    func setGradient(colors: [CGColor]) {
        self.type = .gradient
        self.gradientColors = colors
    }
    
    func setTitle(title: String) {
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 4, y: 0, width: bounds.size.width, height: self.height + 2)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if type == .lottie, let lottieName = self.lottieUrlString {
            if lottieName.starts(with: "http"), let url = URL(string: lottieName) {
                self.bgImage.isHidden = true
                
                Animation.loadedFrom(url: url, closure: { (animation) in
                    if let animation = animation {
                        self.bgLottieView.animation = animation
                        self.bgLottieView.loopMode = .loop
                        self.bgLottieView.contentMode = .scaleToFill
                        self.bgLottieView.backgroundBehavior = .pauseAndRestore
                        self.bgLottieView.play()
                    }
                    else {
                        self.drawDefault()
                    }
                }, animationCache: nil)
                self.bgLottieView.isUserInteractionEnabled = false
                self.addSubview(self.bgLottieView)
                self.sendSubviewToBack(self.bgLottieView)
            }
            else if let animation = Animation.named(lottieName) {
                self.bgImage.isHidden = true
                self.bgLottieView.animation = animation
                self.bgLottieView.isUserInteractionEnabled = false
                self.addSubview(self.bgLottieView)
                self.sendSubviewToBack(self.bgLottieView)
            }
            else {
                drawDefault()
            }
        }
        else if type == .image, let imageName = self.imageUrlString {
            if imageName.starts(with: "http"), let url = URL(string: imageName) {
                self.bgImage.isHidden = false
                self.bgLottieView.isHidden = false
                self.bgImage.sd_setImage(with: url, completed: {(image, error, cache, url) in
                    if error != nil {
                        self.drawDefault()
                    }
                })
            }
            else if let image = UIImage(named: imageName) {
                self.bgImage.isHidden = false
                self.bgLottieView.isHidden = false
                self.bgImage.image = image
            }
            else {
                self.drawDefault()
            }
        }
        else if type == .gradient, let colors = gradientColors {
            self.bgLottieView.isHidden = true
            self.bgImage.isHidden = false
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.colors = colors
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.frame = self.bgImage.bounds
            self.bgImage.layer.insertSublayer(gradient, at: 0)
        }
        
        self.setMinimumTrackImage(UIColor.init(hex: 0x000000, alpha: 0).toImage(), for: .normal)
        self.setMaximumTrackImage(UIColor.init(white: 0.0, alpha: type == .gradient ? 1.0 : 0.8).toImage(), for: .normal)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.valueLabel.text = "\(Int(value))"
        self.bringSubviewToFront(self.valueLabel)
        self.bringSubviewToFront(self.titleLabel)
    }
    
    private func drawDefault() {
        self.type = .gradient
        self.bgLottieView.isHidden = true
        self.bgImage.isHidden = false
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(hex: 0xE0E0E0).cgColor, UIColor(hex: 0x606060).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.bgImage.bounds
        self.bgImage.layer.insertSublayer(gradient, at: 0)
    }
    
}


enum BackgroundType {
    case image, lottie, gradient, none
}

protocol SlideTrackDelegate: AnyObject {
    func endSlideTracking()
}


// MARK: UIColor Extension

extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    func toImage(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
