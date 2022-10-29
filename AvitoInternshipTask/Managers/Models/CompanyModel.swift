import Foundation

struct CompanyModel: Codable {
    let company: CompanyChildModel
}

struct CompanyChildModel: Codable {
    let name: String
    let employees: [EmployeeModel]
}

struct EmployeeModel: Codable {
    let name: String
    let phoneNumber: String
    let skills: [String]
}
