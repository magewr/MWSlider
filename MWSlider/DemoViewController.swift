//
//  DemoViewController.swift
//  MWSlider
//
//  Created by 최우람 on 2022/09/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class DemoViewController: UIViewController {

    
    let imageSlider = MWSlider().then {
        $0.setTitle(title: "image Slider")
        $0.setImage(src: "https://thumbs.dreamstime.com/b/empty-straight-road-top-aerial-view-highway-marking-seamless-roadway-horizontal-template-isolated-white-background-233113314.jpg")
        $0.maximumValue = 100
        $0.value = 50
    }
    
    let lottieSlider = MWSlider().then {
        $0.setTitle(title: "lottie Slider")
        $0.setLottieImage(src: "https://assets2.lottiefiles.com/packages/lf20_fs64xxd6.json")
        $0.maximumValue = 500
        $0.value = 350
    }
    
    let gradationSlider = MWSlider().then {
        $0.setTitle(title: "gradation Slider")
        $0.setGradient(colors: [UIColor(hex: 0x38D790).cgColor, UIColor(hex: 0x4A79F1).cgColor])
        $0.maximumValue = 10
        $0.value = 7
    }
    
    var stackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    private func initView() {
        self.view.backgroundColor = .systemGray5
        
        self.stackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .equalSpacing
            $0.spacing = 48
            $0.addArrangedSubview(self.imageSlider)
            $0.addArrangedSubview(self.lottieSlider)
            $0.addArrangedSubview(self.gradationSlider)
        }
        
        self.view.addSubview(
            self.stackView
        )
        
        self.makeViewConstraints()
        
    }
    
    private func makeViewConstraints() {
        self.stackView.snp.makeConstraints { target in
            target.leading.trailing.equalToSuperview().inset(24)
            target.center.equalToSuperview()
        }
    }


}



