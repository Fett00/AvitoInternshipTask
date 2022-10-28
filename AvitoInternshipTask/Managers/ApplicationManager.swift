import UIKit

class ApplicationManager {

    static public let instance = ApplicationManager()

    let networkManager: NetworkManager
    let coreDataManager: CoreDataManager
    let parseManager: ParseManager

    private init() {

        networkManager = NetworkManager(api: "http://run.mocky.io")!
        coreDataManager = CoreDataManager()
        parseManager = ParseManager()
    }

    func createEntryPoint() -> UIViewController {

        let presenter = LandingPresenter(applicationManager: self)
        let vc = LandingViewController(presenter: presenter)

        presenter.delegate = vc
        return vc
    }
}
