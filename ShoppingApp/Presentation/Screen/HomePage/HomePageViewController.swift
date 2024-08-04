//
//  ViewController.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import UIKit

class HomePageViewController: BaseViewController {
    var viewModel = HomePageViewModel()
    fileprivate let strings = HomePageViewControllerStrings()
    
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
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = AppColors.appBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    lazy var searchField: UITextField = {
        let field = UITextField()
        field.textColor = AppColors.appBlack
        field.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.appBlack.withAlphaComponent(0.5)]

        )
        field.autocorrectionType = .no
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .search
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 8
        field.heightAnchor.constraint(equalToConstant: 40).isActive = true
        field.backgroundColor = AppColors.searchFieldBackground
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if let image = UIImage(named: AssetStrings.search) {
            field.addLeadingIcon(image, imageWidth: 24, padding: 12)
        }
        return field
    }()
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.filter
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = AppColors.appBlack
        return label
    }()
    
    private lazy var filterButton: UIView = {
        let button = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = AppColors.appGray
        button.layer.cornerRadius = 4
        
        label.text = strings.selectFilter
        label.textColor = AppColors.appBlack
        
        button.addSubview(label)
        label.centerInParent()
        button.accessibilityIdentifier = "filterButton"
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFilterButton)))
        return button
    }()
    
    private lazy var productsCollectionViewLayout: LeftAlignedFlowLayout = {
        let layout = LeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = viewModel.contentPadding
        layout.minimumLineSpacing = viewModel.contentPadding
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
}()
        
    lazy var productsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: productsCollectionViewLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 14, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.className)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(style: .noLeading, title: "E-Market")
        setUI()
        fetchData()
    }
    
    //MARK: METHODS
    func setUI() {
        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            searchField.topAnchor.constraint(equalTo: navigationBarViewHolder.bottomAnchor, constant: viewModel.contentPadding),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
        ])
        
        view.addSubview(filterLabel)
        NSLayoutConstraint.activate([
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            filterLabel.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: viewModel.contentPadding)
        ])
        
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            filterButton.topAnchor.constraint(equalTo: filterLabel.topAnchor),
            filterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            filterButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: searchField.topAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([
            emptyStateLabel.topAnchor.constraint(equalTo: searchField.topAnchor),
            emptyStateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(productsCollectionView)
        NSLayoutConstraint.activate([
            productsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            productsCollectionView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: viewModel.contentPadding * 2),
            productsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            productsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -viewModel.padding)
        ])
        
        view.bringSubviewToFront(loadingIndicator)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let updatedText = textField.text else { return }
        viewModel.filterProducts(searchText: updatedText)
        productsCollectionView.reloadData()
        handleEmptyState()
    }
    
    private func fetchData() {
        viewModel.fetchProduct() { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.productsCollectionView.reloadData()
                self.loadingIndicator.stopAnimating()
                self.handleEmptyState()
            }
        }
    }
    
    func handleEmptyState() {
        self.emptyStateLabel.isHidden = self.viewModel.handleEmptyState()
    }
    
    @objc func didTapFilterButton() {
        guard let products = viewModel.products,
        !products.isEmpty else { return }
        let viewController = FilterPageViewController(viewModel: FilterPageViewModel(selectedSortType: viewModel.selectedSoryType,
                                                                                     brands: viewModel.getAllBrandsAsSearchEntities(),
                                                                                     models: viewModel.getAllModelsAsSearchEntities()))
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self

        present(viewController, animated: true)
    }
}

extension HomePageViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel.filteredProductes?.count)~
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.className, for: indexPath) as? ProductCollectionViewCell
        else { return UICollectionViewCell()}
        cell.data = viewModel.filteredProductes?[indexPath.row]
        cell.cellWidth = (productsCollectionView.frame.width / 2.1)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = viewModel.filteredProductes?[indexPath.row] else { return }
        let viewController = DetailPageViewController(viewModel: DetailPageViewModel(product: product))
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)

    }
}

extension HomePageViewController: ProductCellProtocol {
    func addBasket(indexPath: IndexPath) {
        guard let product = viewModel.filteredProductes?[indexPath.row] else { return }
        viewModel.saveProduct(dto: product)
    }
    
    func addFavorite(indexPath: IndexPath) {
        viewModel.updateFavoriteState(index: indexPath.row)
        productsCollectionView.reloadItems(at: [indexPath])
    }
}

extension HomePageViewController: DetailActionProtocol {
    func addToBasket(product: ProductDto) {
        viewModel.saveProduct(dto: product)
    }
    
    func addToFavorite(product: ProductDto) {
        viewModel.updateFavoriteState(for: product)
        productsCollectionView.reloadData()
    }
}

extension HomePageViewController: FilterProtocol {
    func filterBrand(brands: [SearchEntity]?) {
        viewModel.filterProductsByBrands(byBrands: brands)
        productsCollectionView.reloadData()
        handleEmptyState()
    }
    
    func filterModel(models: [SearchEntity]?) {
        viewModel.filterProductsByModels(byModels: models)
        productsCollectionView.reloadData()
        handleEmptyState()
    }
    
    func sort(type: SortType?) {
        viewModel.sortProducts(by: type)
        productsCollectionView.reloadData()
        handleEmptyState()
    }
}

fileprivate struct HomePageViewControllerStrings {
    let search = "Search"
    let filter = "Filters:"
    let emptyState = "Empty State"
    let selectFilter = "Select Filter"
}
