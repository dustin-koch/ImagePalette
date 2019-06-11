//
//  PaletteTableViewCell.swift
//  Palette
//
//  Created by Dustin Koch on 6/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PaletteTableViewCell: UITableViewCell {
    
    //MARK: - Landing pad
    var unsplashPhoto: UnsplashPhoto? {
        didSet {
            updateViews()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        colorPaletteView.colors = [.gray]
    }
    
    func updateViews() {
        guard let unsplashPhoto = unsplashPhoto else { return }
        fetchAndSetImage(for: unsplashPhoto)
        fetchAndSetColors(for: unsplashPhoto)
        paletteTitleLabel.text = unsplashPhoto.description
    }
    
    func fetchAndSetImage(for unsplashPhoto: UnsplashPhoto) {
        UnsplashService.shared.fetchImage(for: unsplashPhoto) { (image) in
            DispatchQueue.main.async {
                self.paletteImageView.image = image
            }
        }
    }
    
    func fetchAndSetColors(for unsplashPhoto: UnsplashPhoto) {
        ImaggaService.shared.fetchColorsFor(imagePath: unsplashPhoto.urls.regular) { (colors) in
                DispatchQueue.main.async {
                    guard let colors = colors else { return }
                    self.colorPaletteView.colors = colors
                }
        }
    }
    
    func addAllSubViews() {
        addSubview(paletteImageView)
        addSubview(paletteTitleLabel)
        addSubview(colorPaletteView)
    }
    
    func setupViews() {
        addAllSubViews()
        let imageWidth = (contentView.frame.width - SpacingConstants.outerHorizontalPadding * 2)
        paletteImageView.anchor(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: SpacingConstants.outerVerticalPadding, paddingBottom: 0, paddingLeading: SpacingConstants.outerHorizontalPadding, paddingTrailing: SpacingConstants.outerHorizontalPadding, width: nil, height: imageWidth)
        paletteTitleLabel.anchor(top: paletteImageView.bottomAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: SpacingConstants.verticalObjectBuffer, paddingBottom: 0, paddingLeading: SpacingConstants.outerHorizontalPadding, paddingTrailing: SpacingConstants.outerHorizontalPadding)
        colorPaletteView.anchor(top: paletteTitleLabel.bottomAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: SpacingConstants.verticalObjectBuffer, paddingBottom: SpacingConstants.outerVerticalPadding, paddingLeading: SpacingConstants.outerHorizontalPadding, paddingTrailing: SpacingConstants.outerHorizontalPadding)
    }
    
    //MARK: - Subviews
    lazy var paletteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var paletteTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var colorPaletteView: ColorPaletteView = {
        let paletteView = ColorPaletteView()
        return paletteView
    }()
    

}
