import UIKit

protocol LandingViewControllerProtocol: AnyObject {

    func reloadData()
}

final class LandingViewController: UIViewController {

    private var collectionView: UICollectionView
    private let collectionViewLayout = UICollectionViewFlowLayout()

    let presenter: LandingPresenterProtocol

    init(
        presenter: LandingPresenterProtocol
    ) {

        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        self.presenter = presenter
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchData()
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

// MARK: - UICollectionViewDataSource
extension LandingViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension LandingViewController: UICollectionViewDelegate {

}
