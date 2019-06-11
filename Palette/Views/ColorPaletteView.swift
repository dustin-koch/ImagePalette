//
//  ColorPaletteView.swift
//  Palette
//
//  Created by DevMountain on 4/1/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class ColorPaletteView: UIView {
    
    var colors: [UIColor]{
        didSet{
            buildColorBricks()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpViews()
    }
    
    init(colors: [UIColor] = [], frame: CGRect = .zero) {
        self.colors = colors
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        addSubview(colorStackView)
        colorStackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0)
        buildColorBricks()
    }
    
    private func generateColorBrick(for color: UIColor) -> UIView {
        let colorBrick = UIView()
        colorBrick.backgroundColor = color
        return colorBrick
    }
    
    private func buildColorBricks(){
        resetColorBricks()
        for color in self.colors {
            let colorBrick = self.generateColorBrick(for: color)
            self.addSubview(colorBrick)
            self.colorStackView.addArrangedSubview(colorBrick)
        }
        self.layoutIfNeeded()
    }
    
    private func resetColorBricks() {
        for subView in colorStackView.arrangedSubviews {
            self.colorStackView.removeArrangedSubview(subView)
        }
    }
    
    //MARK: - SubViews
    lazy var colorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.axis = .horizontal
        return stackView
    }()
}
