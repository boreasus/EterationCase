//
//  RadioButton.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import UIKit

class RadioButton: UIView {
    var isSelected: Bool? {
        didSet {
            configureView()
        }
    }
    
    var type: SortType?
    
    private lazy var outerCircle: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.borderWidth = 2
        circle.layer.borderColor = AppColors.appBlue?.cgColor
        circle.widthAnchor.constraint(equalToConstant: 16).isActive     = true
        circle.heightAnchor.constraint(equalToConstant: 16).isActive    = true
        circle.layer.cornerRadius = 8
        return circle
    }()
    
    private lazy var innerCircle: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.widthAnchor.constraint(equalToConstant: 8).isActive  = true
        circle.heightAnchor.constraint(equalToConstant: 8).isActive = true
        circle.layer.cornerRadius = 4
        return circle
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = AppColors.appBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        if let isSelected,
           !isSelected {
            innerCircle.backgroundColor = AppColors.appWhite
        } else {
            innerCircle.backgroundColor = AppColors.appBlue
        }
    }
    
    func layoutViews() {
        addSubview(outerCircle)
        outerCircle.addSubview(innerCircle)
        addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            outerCircle.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerCircle.topAnchor.constraint(equalTo: topAnchor),
            
            innerCircle.centerXAnchor.constraint(equalTo: outerCircle.centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: outerCircle.centerYAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: outerCircle.trailingAnchor, constant: 8),
            infoLabel.topAnchor.constraint(equalTo: topAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
}
