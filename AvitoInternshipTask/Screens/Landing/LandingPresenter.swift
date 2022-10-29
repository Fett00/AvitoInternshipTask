import Foundation

enum Status {

    case showData
    case showPlaceholder
}

protocol LandingPresenterProtocol {
    func fetchData()
    var data: [PresentationModel] { get }
}

class LandingPresenter: LandingPresenterProtocol {

    private(set) var data: [PresentationModel] = []

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

    private func prepareForPresentation(_ model: CompanyModel) -> [PresentationModel] {
        model.company.employees.map {
            let name = $0.name
            let phoneNumber = "📱 \n" + $0.phoneNumber
            let skills = "💪 \n" + $0.skills.joined(separator: ", ")
            return PresentationModel(name: name, phoneNumber: phoneNumber, skills: skills)
        }
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
            case .success(let model):
                this.data = this.prepareForPresentation(model)
                DispatchQueue.main.async {
                    this.delegate?.reloadData(.showData)
                }
            }
        }
    }
}

struct PresentationModel {
    let name: String
    let phoneNumber: String
    let skills: String
}
