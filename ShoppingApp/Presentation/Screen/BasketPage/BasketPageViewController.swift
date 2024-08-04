//
//  SecondViewController.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import UIKit

class BasketPageViewController: BaseViewController {
    var viewModel = BasketPageViewModel()
    fileprivate let strings = BasketPageViewControllerStrings()
    
    //MARK: VIEWS
    lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.emptyState
        label.textColor = AppColors.appBlue
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    private lazy var productsCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = LeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
        
    lazy var productsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: productsCollectionViewLayout)
        collectionView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BasketCollectionViewCell.self, forCellWithReuseIdentifier: BasketCollectionViewCell.className)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        return label
    }()
    
    private lazy var completeButton: UIView = {
        let button = UIView()
        let buttonLabel = UILabel()
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        buttonLabel.text = strings.complete
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
    
    lazy var totalPriceActionsViewHolder: UIView = {
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
        
        return holder
    }()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(style: .noLeading, title: strings.navigationBarTitle)
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
    }
    
    
    
    //MARK: METHODS
    func setUI() {
        view.addSubview(productsCollectionView)
        view.addSubview(totalPriceActionsViewHolder)
        view.addSubview(emptyStateLabel)
        
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            totalPriceActionsViewHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            totalPriceActionsViewHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            totalPriceActionsViewHolder.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarHeight + viewModel.padding)),
            
            productsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            productsCollectionView.topAnchor.constraint(equalTo: navigationBarViewHolder.bottomAnchor),
            productsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            productsCollectionView.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor, constant: -viewModel.contentPadding),
        ])
    }
    
    func configureViews() {
        viewModel.configureBasket()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.productsCollectionView.reloadData()
            self.viewModel.calculateTotalPrice()
            self.totalPriceLabel.text = "\(String((self.viewModel.totalPrice)~)) ₺"
            self.totalPriceActionsViewHolder.isHidden = self.viewModel.totalPrice == 0
            self.emptyStateLabel.isHidden = self.viewModel.totalPrice != 0
        }
    }
}

extension BasketPageViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasketCollectionViewCell.className, for: indexPath) as? BasketCollectionViewCell
        else { return UICollectionViewCell() }
        cell.cellWidth = productsCollectionView.frame.width
        cell.data = viewModel.products[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
}

extension BasketPageViewController: BasketCellProtocol {
    func add(indexPath: IndexPath) {
        viewModel.addSameProductToBasket(index: indexPath.row)
        configureViews()
    }
    
    func delete(indexPath: IndexPath) {
        viewModel.deleteProductFromBasket(index: indexPath.row)
        configureViews()
    }
}

fileprivate struct BasketPageViewControllerStrings {
    let navigationBarTitle = "E-Market"
    let total = "Total:"
    let complete = "Complete"
    let emptyState = "Empty State"
}
