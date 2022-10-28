import UIKit

protocol LandingViewControllerProtocol {

    func reloadData()
}

final class LandingViewController: UIViewController {

    private var collectionView: UICollectionView
    private let collectionViewLayout = UICollectionViewFlowLayout()

    init() {

        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let superview = collectionView.superview else { return }
        CollectionViewConfigurator.configureFlowLayout(
            superview,
            collectionViewLayout
        )
    }

    private func setupUI() {
        view.backgroundColor = .brown//.systemBackground
        setupCollectionView()
    }

    private func setupCollectionView() {

        let safe = view.safeAreaLayoutGuide
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        NSLayoutConstraint.activate([

            collectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor)
        ])
    }
}

// MARK: - LandingViewControllerProtocol
extension LandingViewController: LandingViewControllerProtocol {
    func reloadData() {
        collectionView.reloadData()
    }
}
