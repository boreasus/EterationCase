//
//  ProductCollectionViewCell.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    let padding: CGFloat = 10
    let contentPadding: CGFloat = 15
    var indexPath: IndexPath?
    weak var delegate: ProductCellProtocol?
    
    var cellWidth: CGFloat? {
        didSet {
            guard let cellWidth else { return }
            self.widthAnchor.constraint(equalToConstant: cellWidth).setPriority(.mainlyrequired).isActive = true
        }
    }
    
    var data: ProductDto? {
        didSet {
            configureViews()
        }
    }
    
    private lazy var productImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return image
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColors.appBlue
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColors.appBlack
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addToCartButton: UIView = {
        let button = UIView()
        let buttonLabel = UILabel()
        
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = AppColors.appBlue
        button.layer.cornerRadius = 4
        
        buttonLabel.text = "Add to Cart"
        buttonLabel.textColor = AppColors.appWhite
        
        button.addSubview(buttonLabel)
        NSLayoutConstraint.activate([
            buttonLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            buttonLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: 8),
            buttonLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -8)
        ])
        
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddBasket)))
        return button
    }()
    
    private lazy var favoriteIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFavIcon)))
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "star.fill")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColors.appWhite
        layer.cornerRadius = 2
        layoutViews()
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
    }
    
    private func layoutViews() {
        addSubview(productImage)
        addSubview(priceLabel)
        addSubview(titleLabel)
        addSubview(addToCartButton)
        addSubview(favoriteIcon)
        
        NSLayoutConstraint.activate([
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            productImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            productImage.heightAnchor.constraint(equalToConstant: 100),

            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            priceLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: contentPadding),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: contentPadding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            addToCartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            addToCartButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: contentPadding),
            addToCartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            addToCartButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),

            favoriteIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(4 + padding)),
            favoriteIcon.topAnchor.constraint(equalTo: topAnchor, constant: 4 + padding),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 24),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        for constraint in constraints {
            constraint.setPriority(.mainlyrequired).isActive = true
        }
    }
    
    private func configureViews() {
        guard let data else { return }
        if let imageUrl = data.image {
            ImageLoader.shared.loadImage(from: imageUrl) { [weak self] image in
                self?.productImage.image = image
            }
        }
        priceLabel.text = data.price
        titleLabel.text = data.name
        if let isFavorited = data.isFavorited,
        !isFavorited {
            favoriteIcon.tintColor = .gray
        } else {
            favoriteIcon.tintColor = AppColors.appYellow
        }
    }
    
    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
     }
    
    @objc func didTapFavIcon() {
        guard let indexPath else { return }
        delegate?.addFavorite(indexPath: indexPath)
    }
    
    @objc func didTapAddBasket() {
        guard let indexPath else { return }
        delegate?.addBasket(indexPath: indexPath)
    }
}
