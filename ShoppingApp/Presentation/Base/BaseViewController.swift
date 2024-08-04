//
//  BaseViewController.swift
//  ShoppingApp
//
//  Created by safa uslu on 2.08.2024.
//

import UIKit

class BaseViewController: UIViewController {
    //MARK: DECLERATIONS
    fileprivate var baseViewModel = BaseViewModel()
    //MARK: VIEWS
    private lazy var leadingIcon: UIImageView = {
        let image = UIImageView(image: UIImage(named: AssetStrings.arrowBack))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 20).isActive     = true
        image.widthAnchor.constraint(equalToConstant: 21.67).isActive   = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapLeadingIcon)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private lazy var navigationBarTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = AppColors.appWhite
        title.font = .boldSystemFont(ofSize: baseViewModel.appBarFontSize)
        return title
    }()
    
    lazy var navigationBarViewHolder: UIView = {
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.backgroundColor = .blue
        view.addSubview(holder)
        NSLayoutConstraint.activate([
            holder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            holder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            holder.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            holder.heightAnchor.constraint(equalToConstant: baseViewModel.appBarHeight)
        ])
        return holder
    }()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.appWhite
        navigationController?.isNavigationBarHidden = true
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: METHODS
    func configureNavigationBar(style: NavigationControllerStyle, title: String) {
        switch style {
        case .withLeading:
            navigationBarTitleLabel.text = title
            navigationBarTitleLabel.numberOfLines = 1
            navigationBarTitleLabel.lineBreakMode = .byTruncatingTail
            navigationBarViewHolder.addSubview(navigationBarTitleLabel)
            navigationBarViewHolder.addSubview(leadingIcon)
            NSLayoutConstraint.activate([
                leadingIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseViewModel.padding),
                leadingIcon.centerYAnchor.constraint(equalTo: navigationBarViewHolder.centerYAnchor),
                
                navigationBarTitleLabel.centerXAnchor.constraint(equalTo: navigationBarViewHolder.centerXAnchor),
                navigationBarTitleLabel.widthAnchor.constraint(equalTo: navigationBarViewHolder.widthAnchor, multiplier: 0.7),
                navigationBarTitleLabel.centerYAnchor.constraint(equalTo: navigationBarViewHolder.centerYAnchor)

            ])
        case .noLeading:
            navigationBarTitleLabel.text = title
            navigationBarViewHolder.addSubview(navigationBarTitleLabel)
            NSLayoutConstraint.activate([
                navigationBarTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: baseViewModel.padding),
                navigationBarTitleLabel.centerYAnchor.constraint(equalTo: navigationBarViewHolder.centerYAnchor)
            ])
        }
    }
    
    @objc func didTapLeadingIcon() {
        navigationController?.popViewController(animated: true)
    }
}

extension BaseViewController {
    enum NavigationControllerStyle {
        case withLeading
        case noLeading
    }
}
