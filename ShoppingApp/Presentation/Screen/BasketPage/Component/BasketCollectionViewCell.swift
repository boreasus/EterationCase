//
//  BasketCollectionViewCell.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import UIKit

class BasketCollectionViewCell: UICollectionViewCell {
    weak var delegate: BasketCellProtocol?
    var indexPath: IndexPath?
    
    var cellWidth: CGFloat? {
        didSet {
            guard let cellWidth else { return }
            self.widthAnchor.constraint(equalToConstant: cellWidth).setPriority(.mainlyrequired).isActive = true
        }
    }
    
    var data: BasketEntity? {
        didSet {
            configureViews()
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = AppColors.appBlack
        return label
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.textColor = AppColors.appBlue
        return label
    }()
    
    private lazy var deleteProductBox: UIView = {
        let holder = UIView()
        let icon = UILabel()
        
        holder.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        icon.text = "-"
        icon.textAlignment = .center
        icon.textColor = AppColors.appBlack
        holder.backgroundColor = AppColors.searchFieldBackground
        
        holder.addSubview(icon)
        icon.centerInParent()
        
        holder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDeleteProductBox)))

        return holder
    }()
    
    private lazy var addProductBox: UIView = {
        let holder = UIView()
        let icon = UILabel()
        
        holder.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        icon.text = "+"
        icon.textAlignment = .center
        icon.textColor = AppColors.appBlack
        holder.backgroundColor = AppColors.searchFieldBackground

        holder.addSubview(icon)
        icon.centerInParent()
        
        holder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddProductBox)))
        
        return holder
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = AppColors.appWhite
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var countProductBox: UIView = {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        
        holder.addSubview(countLabel)
        countLabel.centerInParent()
        
        holder.backgroundColor = AppColors.appBlue
        
        return holder
    }()
    
    private lazy var boxViewHolder: UIView = {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        
        holder.addSubview(deleteProductBox)
        holder.addSubview(addProductBox)
        holder.addSubview(countProductBox)
        
        NSLayoutConstraint.activate([
            deleteProductBox.topAnchor.constraint(equalTo: holder.topAnchor, constant: 2),
            deleteProductBox.bottomAnchor.constraint(equalTo: holder.bottomAnchor, constant: -2),
            deleteProductBox.widthAnchor.constraint(equalTo: deleteProductBox.heightAnchor, multiplier: 1.2),
            
            addProductBox.topAnchor.constraint(equalTo: holder.topAnchor, constant: 2),
            addProductBox.bottomAnchor.constraint(equalTo: holder.bottomAnchor, constant: -2),
            addProductBox.widthAnchor.constraint(equalTo: deleteProductBox.heightAnchor, multiplier: 1.2),
            
            countProductBox.topAnchor.constraint(equalTo: holder.topAnchor, constant: 2),
            countProductBox.bottomAnchor.constraint(equalTo: holder.bottomAnchor, constant: -2),
            countProductBox.widthAnchor.constraint(equalTo: deleteProductBox.heightAnchor, multiplier: 1.2),
            
            deleteProductBox.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            countProductBox.leadingAnchor.constraint(equalTo: deleteProductBox.trailingAnchor),
            addProductBox.leadingAnchor.constraint(equalTo: countProductBox.trailingAnchor),
            
            addProductBox.trailingAnchor.constraint(equalTo: holder.trailingAnchor)
        ])
        return holder
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutViews() {
        addSubview(nameLabel)
        addSubview(moneyLabel)
        addSubview(boxViewHolder)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            
            moneyLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            moneyLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            moneyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            
            boxViewHolder.trailingAnchor.constraint(equalTo: trailingAnchor),
            boxViewHolder.topAnchor.constraint(equalTo: topAnchor),
            boxViewHolder.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func configureViews() {
        guard let data else { return }
        nameLabel.text = data.product.name
        moneyLabel.text = data.product.price
        countLabel.text = String(data.productCount)
    }
    
    @objc func didTapAddProductBox() {
        guard let indexPath else { return }
        delegate?.add(indexPath: indexPath)
    }
    
    @objc func didTapDeleteProductBox() {
        guard let indexPath else { return }
        delegate?.delete(indexPath: indexPath)
    }
}
