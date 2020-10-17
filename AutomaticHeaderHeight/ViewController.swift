//
//  ViewController.swift
//  AutomaticHeaderHeight
//
//  Created by Jan Nash on 17.10.20.
//

import UIKit


class TestHeader: UICollectionReusableView {
    // Initializers
    required init?(coder: NSCoder) { fatalError() }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    override var translatesAutoresizingMaskIntoConstraints: Bool {
        willSet {
            print()
        }
    }
}


class ViewController: UICollectionViewController {
    // Initializers
    required init?(coder: NSCoder) { fatalError() }
    init() {
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.headerMode = .supplementary
        listConfig.showsSeparators = false
        
        super.init(collectionViewLayout: UICollectionViewCompositionalLayout.list(using: listConfig))
    }
    
    // DataSource
    typealias DataSource = UICollectionViewDiffableDataSource<String, String>
    private lazy var dataSource: DataSource = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, String>() { _, _, _ in }
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TestHeader>(elementKind: "Header") { _, _, _ in }
        
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { $0.dequeueConfiguredReusableCell(using: cellRegistration, for: $1, item: $2) }
        )
        
        dataSource.supplementaryViewProvider = {
            let view = $0.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: $2)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
        
        return dataSource
    }()
    
    // View Lifecycle Overrides
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(["Foo"])
        dataSource.apply(snapshot)
    }
}

