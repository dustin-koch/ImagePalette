//
//  PaletteListViewController.swift
//  Palette
//
//  Created by Dustin Koch on 6/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PaletteListViewController: UIViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewSpace: CGFloat  = (view.frame.width - (2 * SpacingConstants.outerHorizontalPadding))
        let titleLableSpace: CGFloat = SpacingConstants.oneLineElementHeight
        let colorPaletteViewSpace: CGFloat = SpacingConstants.twoLineElementHeight
        let verticalPadding: CGFloat = (3 * SpacingConstants.verticalObjectBuffer)
        let outerVerticalPadding: CGFloat = (2 * SpacingConstants.outerVerticalPadding)
        
        return imageViewSpace + titleLableSpace + colorPaletteViewSpace + verticalPadding + outerVerticalPadding
    }
    
    //MARK: - Properties
    var photos: [UnsplashPhoto] = []
    
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var buttons: [UIButton] {
        return [randomButton, featuredButton, doubleRainbowButton]
    }
    

    override func loadView() {
        super.loadView()
        addAllSubViews()
        setupStackView()
        paletteTableView.anchor(top: buttonStackView.bottomAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 8, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activateButtons()
        selectButton(featuredButton)
        configureTableView()
        searchForCategory(.featured)
    }
    
    func addAllSubViews() {
        view.addSubview(featuredButton)
        view.addSubview(randomButton)
        view.addSubview(doubleRainbowButton)
        view.addSubview(buttonStackView)
        view.addSubview(paletteTableView)
    }
    
    func setupStackView() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(featuredButton)
        buttonStackView.addArrangedSubview(randomButton)
        buttonStackView.addArrangedSubview(doubleRainbowButton)
//        buttonStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
//        buttonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
//        buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        //same thing as above
        buttonStackView.anchor(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 16, paddingBottom: 16, paddingLeading: 16, paddingTrailing: -16)
    }
    
    func configureTableView() {
        paletteTableView.dataSource = self
        paletteTableView.delegate = self
        paletteTableView.register(PaletteTableViewCell.self, forCellReuseIdentifier: "colorCell")
        paletteTableView.allowsSelection = false
    }
    
    func searchForCategory (_ unsplashRoute: UnsplashRoute) {
        UnsplashService.shared.fetchFromUnsplash(for: unsplashRoute) { (photos) in
            guard let photos = photos else { return }
            self.photos = photos
            DispatchQueue.main.async {
                self.paletteTableView.reloadData()
            }
        }
    }
    
    func activateButtons() {
        buttons.forEach{$0.addTarget(self, action: #selector(searchButtonTapped(sender:)), for: .touchUpInside)}
    }
    func selectButton(_ button: UIButton) {
        buttons.forEach{$0.setTitleColor(UIColor.lightGray, for: .normal)}
        button.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
    }

    //MARK: - Views
    
    //Buttons and stack view
    let featuredButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Feature", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Random", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    let doubleRainbowButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Double Rainbow", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    let paletteTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    @objc func searchButtonTapped(sender: UIButton) {
        selectButton(sender)
        switch sender {
        case featuredButton:
            searchForCategory(.featured)
        case randomButton:
            searchForCategory(.random)
        case doubleRainbowButton:
            searchForCategory(.doubleRainbow)
        default:
            print("How did you find the fourth button? 🤪")
        }
    }
    
}//END OF CLASS

extension PaletteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as? PaletteTableViewCell else { return UITableViewCell()}
        let unsplashPhoto = photos[indexPath.row]
        cell.unsplashPhoto = unsplashPhoto
        
        return cell
    }
    
    
}
