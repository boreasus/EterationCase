//
//  FilterPageViewController.swift
//  ShoppingApp
//
//  Created by safa uslu on 4.08.2024.
//

import UIKit

class FilterPageViewController: BaseViewController {
    weak var delegate: FilterProtocol?
    var viewModel: FilterPageViewModel
    fileprivate let strings = FilterPageViewControllerStrings()
    
    //MARK: VIEWS
    private lazy var leadingIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: AssetStrings.cross))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive  = true
        icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeadingIcon)))
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.filter
        label.font = .systemFont(ofSize: 20)
        label.textColor = AppColors.appBlack
        return label
    }()
    
    private lazy var titleViewHolder: UIView = {
        let holder = UIView()
        let padding: CGFloat = 24
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.backgroundColor = .white
        
        holder.layer.shadowColor = UIColor.black.cgColor
        holder.layer.shadowOpacity = 0.1
        holder.layer.shadowOffset = CGSize(width: 0, height: 4)
        holder.layer.shadowRadius = 4
        holder.layer.cornerRadius = 8
        
        holder.addSubview(leadingIcon)
        holder.addSubview(pageTitle)
        
        NSLayoutConstraint.activate([
            leadingIcon.leadingAnchor.constraint(equalTo: holder.leadingAnchor, constant: padding),
            leadingIcon.topAnchor.constraint(equalTo: holder.topAnchor, constant: padding),
            leadingIcon.bottomAnchor.constraint(equalTo: holder.bottomAnchor, constant: -padding),
            
            pageTitle.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            pageTitle.centerYAnchor.constraint(equalTo: holder.centerYAnchor)
        ])
        
        return holder
    }()
    
    private lazy var sortLabel: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.sortBy
        label.font = .systemFont(ofSize: 12)
        label.textColor = AppColors.textGray
        return label
    }()
    
    private lazy var oldToNewRadioButton = radioButtonBuilder(isSelected: false, labelText: strings.oldToNew, type: .oldToNew)
    
    private lazy var newToOldRadioButton = radioButtonBuilder(isSelected: false, labelText: strings.oldToNew, type: .newToOld)
    
    private lazy var priceAscendingRadioButton = radioButtonBuilder(isSelected: false, labelText: strings.priceAscending, type: .priceDescending)
    
    private lazy var priceDescendingRadioButton = radioButtonBuilder(isSelected: false, labelText: strings.priceDescending, type: .priceAscending)
    
    private lazy var sortByViewHolder: UIView = {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        
        holder.addSubview(sortLabel)
        holder.addSubview(oldToNewRadioButton)
        holder.addSubview(newToOldRadioButton)
        holder.addSubview(priceAscendingRadioButton)
        holder.addSubview(priceDescendingRadioButton)
        
        NSLayoutConstraint.activate([
            sortLabel.topAnchor.constraint(equalTo: holder.topAnchor),
            sortLabel.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            
            oldToNewRadioButton.leadingAnchor.constraint(equalTo: holder.leadingAnchor, constant: viewModel.contentPadding),
            oldToNewRadioButton.trailingAnchor.constraint(equalTo: holder.trailingAnchor, constant: -viewModel.contentPadding),
            oldToNewRadioButton.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 20),
            
            newToOldRadioButton.leadingAnchor.constraint(equalTo: oldToNewRadioButton.leadingAnchor),
            newToOldRadioButton.trailingAnchor.constraint(equalTo: holder.trailingAnchor, constant: -viewModel.contentPadding),
            newToOldRadioButton.topAnchor.constraint(equalTo: oldToNewRadioButton.bottomAnchor, constant: viewModel.contentPadding),
            
            priceAscendingRadioButton.leadingAnchor.constraint(equalTo: newToOldRadioButton.leadingAnchor),
            priceAscendingRadioButton.trailingAnchor.constraint(equalTo: holder.trailingAnchor, constant: -viewModel.contentPadding),
            priceAscendingRadioButton.topAnchor.constraint(equalTo: newToOldRadioButton.bottomAnchor, constant: viewModel.contentPadding),
            
            priceDescendingRadioButton.leadingAnchor.constraint(equalTo: priceAscendingRadioButton.leadingAnchor),
            priceDescendingRadioButton.trailingAnchor.constraint(equalTo: holder.trailingAnchor, constant: -viewModel.contentPadding),
            priceDescendingRadioButton.topAnchor.constraint(equalTo: priceAscendingRadioButton.bottomAnchor, constant: viewModel.contentPadding),
            priceDescendingRadioButton.bottomAnchor.constraint(equalTo: holder.bottomAnchor)
        ])
        
        oldToNewRadioButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRadioButtonOldToNew)))
        newToOldRadioButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRadioButtonNewToOld)))
        priceAscendingRadioButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRadioButtonDescending)))
        priceDescendingRadioButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapRadioButtonAscending)))
        
        holder.isUserInteractionEnabled = true
        return holder
    }()
    
    private lazy var dividerFirst: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = AppColors.appBlack.withAlphaComponent(0.5)
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }()
    
    private lazy var brandLabel: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.brand
        label.font = .systemFont(ofSize: 12)
        label.textColor = AppColors.textGray
        return label
    }()
    
    private lazy var brandSearchField: UITextField = {
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
        field.addTarget(self, action: #selector(brandTextFieldDidChange(_:)), for: .editingChanged)
        
        if let image = UIImage(named: AssetStrings.search) {
            field.addLeadingIcon(image, imageWidth: 24, padding: 12)
        }
        return field
    }()
    
    private lazy var brandCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = LeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = viewModel.contentPadding
        layout.minimumLineSpacing = viewModel.contentPadding
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
        
    lazy var brandCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: brandCollectionViewLayout)
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CheckBoxCollectionViewCell.self, forCellWithReuseIdentifier: CheckBoxCollectionViewCell.className)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var brandViewHolder: UIView = {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.addSubview(brandLabel)
        holder.addSubview(brandSearchField)
        holder.addSubview(brandCollectionView)
        NSLayoutConstraint.activate([
            brandLabel.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            brandLabel.topAnchor.constraint(equalTo: holder.topAnchor),
            
            brandSearchField.leadingAnchor.constraint(equalTo: holder.leadingAnchor, constant: viewModel.contentPadding),
            brandSearchField.topAnchor.constraint(equalTo: brandLabel.bottomAnchor, constant: viewModel.contentPadding),
            brandSearchField.trailingAnchor.constraint(equalTo: holder.trailingAnchor, constant: -viewModel.contentPadding),
            
            brandCollectionView.leadingAnchor.constraint(equalTo: brandSearchField.leadingAnchor),
            brandCollectionView.trailingAnchor.constraint(equalTo: brandSearchField.trailingAnchor, constant: -viewModel.contentPadding),
            brandCollectionView.topAnchor.constraint(equalTo: brandSearchField.bottomAnchor, constant: 5),
            brandCollectionView.bottomAnchor.constraint(equalTo: holder.bottomAnchor)

        ])
        return holder
    }()
    
    //---
    
    private lazy var dividerSecond: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = AppColors.appBlack.withAlphaComponent(0.5)
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }()
    
    private lazy var modelLabel: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = strings.model
        label.font = .systemFont(ofSize: 12)
        label.textColor = AppColors.textGray
        return label
    }()
    
    private lazy var modelSearchField: UITextField = {
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
        field.addTarget(self, action: #selector(modelTextFieldDidChange(_:)), for: .editingChanged)
        
        if let image = UIImage(named: AssetStrings.search) {
            field.addLeadingIcon(image, imageWidth: 24, padding: 12)
        }
        return field
    }()
    
    private lazy var modelCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = LeftAlignedFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = viewModel.contentPadding
        layout.minimumLineSpacing = viewModel.contentPadding
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
        
    lazy var modelCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: modelCollectionViewLayout)
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CheckBoxCollectionViewCell.self, forCellWithReuseIdentifier: CheckBoxCollectionViewCell.className)
        collectionView.showsVerticalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var modelViewHolder: UIView = {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.addSubview(modelLabel)
        holder.addSubview(modelSearchField)
        holder.addSubview(modelCollectionView)
        NSLayoutConstraint.activate([
            modelLabel.leadingAnchor.constraint(equalTo: holder.leadingAnchor),
            modelLabel.topAnchor.constraint(equalTo: holder.topAnchor),
            
            modelSearchField.leadingAnchor.constraint(equalTo: holder.leadingAnchor, constant: viewModel.contentPadding),
            modelSearchField.topAnchor.constraint(equalTo: modelLabel.bottomAnchor, constant: viewModel.contentPadding),
            modelSearchField.trailingAnchor.constraint(equalTo: holder.trailingAnchor, constant: -viewModel.contentPadding),
            
            modelCollectionView.leadingAnchor.constraint(equalTo: modelSearchField.leadingAnchor),
            modelCollectionView.trailingAnchor.constraint(equalTo: modelSearchField.trailingAnchor, constant: -viewModel.contentPadding),
            modelCollectionView.topAnchor.constraint(equalTo: modelSearchField.bottomAnchor, constant: 5),
            modelCollectionView.bottomAnchor.constraint(equalTo: holder.bottomAnchor)

        ])
        return holder
    }()
    
    lazy var primaryButton: UIView = {
        let button = UIView()
        let label = UILabel()
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = AppColors.appBlue
        button.layer.cornerRadius = 4
        label.text = strings.primary
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = AppColors.appWhite
        button.addSubview(label)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPrimaryButton)))
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.topAnchor.constraint(equalTo: button.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -8)
        ])
        
        return button
    }()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    init(viewModel: FilterPageViewModel) {
          self.viewModel = viewModel
          super.init(nibName: nil, bundle: nil)
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: METHODS
    func setUI() {
        view.addSubview(titleViewHolder)
        NSLayoutConstraint.activate([
            titleViewHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleViewHolder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleViewHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.addSubview(sortByViewHolder)
        NSLayoutConstraint.activate([
            sortByViewHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            sortByViewHolder.topAnchor.constraint(equalTo: titleViewHolder.bottomAnchor, constant: viewModel.contentPadding),
            sortByViewHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding)
        ])
        
        view.addSubview(dividerFirst)
        NSLayoutConstraint.activate([
            dividerFirst.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            dividerFirst.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            dividerFirst.topAnchor.constraint(equalTo: sortByViewHolder.bottomAnchor, constant: viewModel.contentPadding)
        ])
        
        view.addSubview(brandViewHolder)
        NSLayoutConstraint.activate([
            brandViewHolder.heightAnchor.constraint(equalTo: sortByViewHolder.heightAnchor, multiplier: 1.1),
            brandViewHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            brandViewHolder.topAnchor.constraint(equalTo: dividerFirst.bottomAnchor, constant: viewModel.contentPadding),
            brandViewHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
        ])
        
        view.addSubview(dividerSecond)
        NSLayoutConstraint.activate([
            dividerSecond.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            dividerSecond.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
            dividerSecond.topAnchor.constraint(equalTo: brandViewHolder.bottomAnchor, constant: viewModel.contentPadding)
        ])
        
        view.addSubview(modelViewHolder)
        NSLayoutConstraint.activate([
            modelViewHolder.heightAnchor.constraint(equalTo: sortByViewHolder.heightAnchor, multiplier: 1.1),
            modelViewHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            modelViewHolder.topAnchor.constraint(equalTo: dividerSecond.bottomAnchor, constant: viewModel.contentPadding),
            modelViewHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding),
        ])
        
        view.addSubview(primaryButton)
        NSLayoutConstraint.activate([
            primaryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: viewModel.padding),
            primaryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -viewModel.padding),
            primaryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -viewModel.padding)
        ])
        
        handleRadioButtonState()
    }
    
    @objc override func didTapLeadingIcon() {
        self.dismiss(animated: true)
    }
    
    func handleRadioButtonState(clear: Bool? = false) {
        sortByViewHolder.subviews.forEach { view in
            if let radioButton = view as? RadioButton {
                radioButton.isSelected = radioButton.type == viewModel.selectedSortType
                if let clear, clear {
                    radioButton.isSelected = false
                    viewModel.selectedSortType = nil
                }
            }
        }
    }
    
    @objc func didTapRadioButtonOldToNew() {
        viewModel.selectedSortType = .oldToNew
        handleRadioButtonState(clear: (oldToNewRadioButton.isSelected == true))
    }
    
    @objc func didTapRadioButtonNewToOld() {
        viewModel.selectedSortType = .newToOld
        handleRadioButtonState(clear: (newToOldRadioButton.isSelected == true))
    }
    
    @objc func didTapRadioButtonAscending() {
        viewModel.selectedSortType = .priceAscending
        handleRadioButtonState(clear: (priceDescendingRadioButton.isSelected == true))
    }
    
    @objc func didTapRadioButtonDescending() {
        viewModel.selectedSortType = .priceDescending
        handleRadioButtonState(clear: (priceAscendingRadioButton.isSelected == true))
    }
    
    @objc func brandTextFieldDidChange(_ textField: UITextField) {
        guard let updatedText = textField.text else { return }
        viewModel.filterBrands(searchText: updatedText)
        brandCollectionView.reloadData()
    }
    
    @objc func modelTextFieldDidChange(_ textField: UITextField) {
        guard let updatedText = textField.text else { return }
        viewModel.filterModels(searchText: updatedText)
        modelCollectionView.reloadData()
    }
    
    @objc func didTapPrimaryButton() {
        delegate?.filterBrand(brands: viewModel.getSelectedBrands())
        delegate?.filterModel(models: viewModel.getSelectedModels())
        delegate?.sort(type: viewModel.selectedSortType)
        self.dismiss(animated: true)
    }
}

extension FilterPageViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == brandCollectionView {
            return (viewModel.filteredBrands?.count)~
        }
        return (viewModel.filteredModels?.count)~
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == brandCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCollectionViewCell.className, for: indexPath) as? CheckBoxCollectionViewCell
            else { return UICollectionViewCell() }
            cell.data = viewModel.filteredBrands?[indexPath.row]
            cell.cellWidth = brandCollectionView.frame.width
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCollectionViewCell.className, for: indexPath) as? CheckBoxCollectionViewCell
        else { return UICollectionViewCell() }
        cell.data = viewModel.filteredModels?[indexPath.row]
        cell.cellWidth = modelCollectionView.frame.width
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == brandCollectionView {
            viewModel.updateBrandSelectionState(index: indexPath.row)
            brandCollectionView.reloadData()
        } else {
            viewModel.updateModelSelectionState(index: indexPath.row)
            modelCollectionView.reloadData()
        }
    }
}

fileprivate func radioButtonBuilder(isSelected: Bool, labelText: String, type: SortType) -> RadioButton {
    let radioButton = RadioButton()
    radioButton.translatesAutoresizingMaskIntoConstraints = false
    radioButton.isSelected = isSelected
    radioButton.infoLabel.text = labelText
    radioButton.type = type
    radioButton.isUserInteractionEnabled = true
    return radioButton
}

fileprivate struct FilterPageViewControllerStrings {
    let filter = "Filter"
    let sortBy = "Sort By "
    let oldToNew = "Old to new"
    let newToOld = "Old to new"
    let priceAscending = "Price high to low"
    let priceDescending = "Price low to high"
    let brand = "Brand"
    let model = "Model"
    let primary = "Primary"
}
