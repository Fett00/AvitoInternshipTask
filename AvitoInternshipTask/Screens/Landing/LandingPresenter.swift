import Foundation

enum Status {

    case showData
    case showPlaceholder
}

protocol LandingPresenterProtocol {
    func fetchData()
    var data: CompanyModel? { get }
}

class LandingPresenter: LandingPresenterProtocol {

    private(set) var data: CompanyModel?

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
            coreData: applicationManager.coreDataManager,
            parseManager: applicationManager.parseManager
        )
    }

    func fetchData() {

        queue.async { [weak self] in
            guard let this = self else { return }
            let result = this.dataManager.fetchData()

            switch result {

            case .failure(_):
                DispatchQueue.main.async {
                    this.delegate?.reloadData(.showPlaceholder)
                }
            case .success(let models):
                this.data = models
                DispatchQueue.main.async {
                    this.delegate?.reloadData(.showData)
                }
            }
        }
    }
}
