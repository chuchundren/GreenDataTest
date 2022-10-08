//
//  UserListViewController.swift
//  GreenDataTest
//
//  Created by Dasha Palshau on 06.10.2022.
//

import UIKit

class UserListViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UserListViewController.listLayout())
    private var viewModel: UserListViewModel
    private var randomUsers: [RandomUser] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        configureConstraints()
        setupCollectionView()
        viewModel.requestUsersForTheNextPage { [weak self] users in
            self?.randomUsers.append(contentsOf: users)
        }
    }
    
    private func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserListCell.self, forCellWithReuseIdentifier: UserListCell.reuseIdentifier)
        collectionView.register(LoaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoaderReusableView.reuseIdentifier)
        collectionView.backgroundColor = .clear
    }
    
    private static func listLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(100.0))
        
        let section = NSCollectionLayoutSection(group: group)
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        section.boundarySupplementaryItems = [footer]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

extension UserListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        randomUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserListCell.reuseIdentifier, for: indexPath) as? UserListCell
        let user = randomUsers[indexPath.item]
        cell?.configure(with: viewModel.formatName(of: user))
        
        cell?.cancelLoading = viewModel.loadImage(url: user.picture.large) { image in
            if let image = image {
                DispatchQueue.main.async {
                    cell?.configure(with: image)
                }
            }
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoaderReusableView.reuseIdentifier, for: indexPath) as? LoaderReusableView else {
                fatalError()
            }
            
            return footerView
        }
        
        fatalError()
    }
    
}

extension UserListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.didAskToOpenProfile(of: randomUsers[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        viewModel.requestUsersForTheNextPage { [weak self] users in
            self?.randomUsers.append(contentsOf: users)
        }
    }
}
