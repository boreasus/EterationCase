//
//  CheckBoxCollectionViewCell.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import UIKit

class CheckBoxCollectionViewCell: UICollectionViewCell {
    var data: SearchEntity? {
        didSet {
            configureViews()
        }
    }
    
    var cellWidth: CGFloat? {
        didSet {
            guard let cellWidth else { return }
            self.widthAnchor.constraint(equalToConstant: cellWidth).setPriority(.mainlyrequired).isActive = true
        }
    }
    
    private lazy var outerCircle: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.borderWidth = 2
        circle.layer.borderColor = AppColors.appBlue?.cgColor
        circle.widthAnchor.constraint(equalToConstant: 16).isActive     = true
        circle.heightAnchor.constraint(equalToConstant: 16).isActive    = true
        circle.layer.cornerRadius = 2
        return circle
    }()
    
    private lazy var checkMark: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "checkmark")
        icon.tintColor = AppColors.appWhite
        return icon
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
    
    func configureViews() {
        guard let data else { return }
        infoLabel.text = data.title
        if !data.isSelected {
            outerCircle.backgroundColor = AppColors.appWhite
        } else {
            outerCircle.backgroundColor = AppColors.appBlue
        }
    }
    
    func layoutViews() {
        addSubview(outerCircle)
        outerCircle.addSubview(checkMark)
        addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            outerCircle.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerCircle.topAnchor.constraint(equalTo: topAnchor),
            
            checkMark.centerXAnchor.constraint(equalTo: outerCircle.centerXAnchor),
            checkMark.centerYAnchor.constraint(equalTo: outerCircle.centerYAnchor),
            checkMark.heightAnchor.constraint(equalTo: outerCircle.heightAnchor, multiplier: 0.8),
            checkMark.widthAnchor.constraint(equalTo: outerCircle.widthAnchor, multiplier: 0.8),
            
            infoLabel.leadingAnchor.constraint(equalTo: outerCircle.trailingAnchor, constant: 8),
            infoLabel.topAnchor.constraint(equalTo: topAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
}
