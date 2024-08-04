//
//  DetailScreenViewController.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import UIKit

class DetailPageViewController: BaseViewController {
    var viewModel: DetailPageViewModel?
    fileprivate let strings = DetailPageViewControllerStrings()
    weak var delegate: DetailActionProtocol?
    
    //MARK: VIEWS
    
    private lazy var productImage: UIImageView = {
        var imageHolder = UIImageView()
        imageHolder.translatesAutoresizingMaskIntoConstraints = false
        if let imageUrl = viewModel?.product?.image {
            ImageLoader.shared.loadImage(from: imageUrl) { [weak self] image in
                imageHolder.image = image
            }
        }
        return imageHolder
    }()
    
    lazy var favoriteIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFavIcon)))
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "star.fill")
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColors.appBlack
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.text = viewModel?.product?.name
        label.textAlignment = .left
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    lazy var descriptionLabel: TopAlignedLabel = {
        let label = TopAlignedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColors.appBlack
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = viewModel?.product?.description
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.total
        label.textColor = AppColors.appBlue
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppColors.appBlack
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.text = "\((viewModel?.product?.price)~) ₺"
        return label
    }()
    
    private lazy var completeButton: UIView = {
        let button = UIView()
        let buttonLabel = UILabel()
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLabel.text = strings.addToBasket
        buttonLabel.font = .systemFont(ofSize: 18, weight: .bold)
        buttonLabel.textColor = AppColors.appWhite
        buttonLabel.textAlignment = .center
        
        button.layer.cornerRadius = 4
        button.backgroundColor = AppColors.appBlue
        button.addSubview(buttonLabel)
        
        NSLayoutConstraint.activate([
            buttonLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: 8),
            buttonLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -8),
            buttonLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
        ])
        
        return button
    }()
    
    private lazy var totalPriceActionsViewHolder: UIView = {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.addSubview(totalLabel)
        holder.addSubview(totalPriceLabel)
        holder.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            totalLabel.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            totalLabel.topAnchor.constraint(equalTo: holder.topAnchor),
            
            totalPriceLabel.leadingAnchor.constraint(equalTo: totalLabel.leadingAnchor),
            totalPriceLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 2),
            totalPriceLabel.bottomAnchor.constraint(equalTo: holder.bottomAnchor),
            
            completeButton.trailingAnchor.constraint(equalTo: holder.trailingAnchor),
            completeButton.topAnchor.constraint(equalTo: holder.topAnchor),
            completeButton.bottomAnchor.constraint(equalTo: holder.bottomAnchor),
            completeButton.widthAnchor.constraint(equalTo: holder.widthAnchor, multiplier: 0.5)
        ])
        holder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddBasket)))
        return holder
    }()
    
    
    //MARK: LIFECYCLE
    init(viewModel: DetailPageViewModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(style: .withLeading, title: (viewModel?.product?.name)~)
        setUI()
    }
    
    //MARK: METHODS
    func setUI() {
        view.addSubview(productImage)
        view.addSubview(totalPriceActionsViewHolder)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(favoriteIcon)
        
        guard let viewModel,
              let tabBarHeight = tabBarController?.tabBar.frame.height else { return }

        NSLayoutConstraint.activate([
            productImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            productImage.topAnchor.constraint(equalTo: navigationBarViewHolder.bottomAnchor, constant: viewModel.contentPadding),
            productImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor, multiplier: 0.626),
            
            favoriteIcon.trailingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: -viewModel.contentPadding),
            favoriteIcon.topAnchor.constraint(equalTo: productImage.topAnchor, constant: viewModel.contentPadding),
            
            totalPriceActionsViewHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            totalPriceActionsViewHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            totalPriceActionsViewHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarHeight + viewModel.padding)),
            
            titleLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: viewModel.contentPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: viewModel.contentPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            descriptionLabel.bottomAnchor.constraint(equalTo: totalPriceActionsViewHolder.topAnchor, constant: -viewModel.contentPadding)
        ])
        if let product = viewModel.product {
            configureFavIcon(product: product)
        }
    }
    
    func configureFavIcon(product: ProductDto) {
        if let isFavorited = product.isFavorited,
        !isFavorited {
            favoriteIcon.tintColor = .gray
        } else {
            favoriteIcon.tintColor = AppColors.appYellow
        }
    }
    
    @objc func didTapFavIcon() {
        viewModel?.product?.isFavorited?.toggle()
        guard let product = viewModel?.product else { return }
        delegate?.addToFavorite(product: product)
        configureFavIcon(product: product)
    }
    
    @objc func didTapAddBasket() {
        guard let product = viewModel?.product else { return }
        delegate?.addToBasket(product: product)
    }
}

fileprivate struct DetailPageViewControllerStrings {
    let total = "Total:"
    let addToBasket = "Add to Cart"
}
