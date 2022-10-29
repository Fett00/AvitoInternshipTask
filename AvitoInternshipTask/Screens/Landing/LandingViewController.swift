import UIKit

protocol LandingViewControllerProtocol: AnyObject {

    func reloadData(_ status: Status)
}

final class LandingViewController: UIViewController {

    private let collectionView: UICollectionView
    private let collectionViewLayout = UICollectionViewFlowLayout()
    private let refresh = UIRefreshControl()
    private let placeholder = LandingPlaceholder(frame: .zero)

    let presenter: LandingPresenterProtocol

    init(
        presenter: LandingPresenterProtocol
    ) {

        collectionView = UICollectionView(
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
            collectionView,
            collectionViewLayout
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchData()
    }

    @objc private func refreshAction() {
        presenter.fetchData()
        refresh.endRefreshing()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupCollectionView()

        refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)

        view.addSubview(placeholder)
        placeholder.addTargetForButton(target: self, action: #selector(tapRefreshButton), for: .touchUpInside)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.alpha = 0.0
        NSLayoutConstraint.activate([
            placeholder.topAnchor.constraint(equalTo: view.topAnchor),
            placeholder.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            placeholder.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholder.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupCollectionView() {

        collectionView.delegate = self
        collectionView.dataSource = self
        CollectionViewConfigurator.configureCollection(collectionView)

        let safe = view.safeAreaLayoutGuide
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refresh

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor)
        ])
    }

    @objc private func tapRefreshButton() {
        presenter.fetchData()
    }
}

// MARK: - LandingViewControllerProtocol
extension LandingViewController: LandingViewControllerProtocol {
    func reloadData(_ status: Status) {

        switch status {
        case .showData:
            placeholder.hide()
            collectionView.reloadData()
        case .showPlaceholder:
            placeholder.showWithCause(.cantLoad)
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension LandingViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandingEmploeeCell.reuseID, for: indexPath) as? LandingEmploeeCell else {
            return UICollectionViewCell()
        }
        cell.update(presenter.data[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension LandingViewController: UICollectionViewDelegate {

}
