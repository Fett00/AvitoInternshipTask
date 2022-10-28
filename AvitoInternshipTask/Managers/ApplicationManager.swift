import UIKit

class ApplicationManager {

    static public let instance = ApplicationManager()

    let networkManager: NetworkManager
    let coreDataManager: CoreDataManager

    private init() {

        networkManager = NetworkManager(api: "https://run.mocky.io")!
        coreDataManager = CoreDataManager()
    }

    func createEntryPoint() -> UIViewController {

        let presenter = LandingPresenter(applicationManager: self)
        let vc = LandingViewController(presenter: presenter)

        presenter.delegate = vc
        return vc
    }
}
