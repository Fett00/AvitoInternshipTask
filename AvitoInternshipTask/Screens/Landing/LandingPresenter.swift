import Foundation

protocol LandingPresenterProtocol {
    func fetchData()
    var data: [CompanyModel] { get }
}

class LandingPresenter: LandingPresenterProtocol {

    private(set) var data: [CompanyModel] = []

    private let dataManager: DataManagerProtocol
    private let queue: DispatchQueue = DispatchQueue(
        label: "landing.presenter.background",
        qos: .userInteractive,
        attributes: [.concurrent]
    )

    weak var delegate: LandingViewControllerProtocol?

    init(applicationManager: ApplicationManager) {

        dataManager = DataManager(
            network: applicationManager.networkManager,
            coreData: applicationManager.coreDataManager
        )
    }

    func fetchData() {

        queue.async { [weak self] in
            guard let this = self else { return }
            this.data = this.dataManager.fetchData()
            DispatchQueue.main.async {
                this.delegate?.reloadData()
            }
        }
    }
}
