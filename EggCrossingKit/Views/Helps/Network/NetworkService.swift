
import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    var errorStatus: ((NetworkError) -> Void)?
    
    func getAppData(_ url: String) async throws -> ResnonseData {
        guard let url = URL(string: url) else {
            errorStatus?(.invalidURL)
            throw NetworkError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            errorStatus?(.invalidResponse)
            throw NetworkError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(ResnonseData.self,
                                            from: data)
        case 404:
            errorStatus?(.notDataFound)
            throw NetworkError.notDataFound
        default:
            errorStatus?(.serverCodeError(statusCode: httpResponse.statusCode,
                                          message: httpResponse.debugDescription))
            throw NetworkError.serverCodeError(
                statusCode: httpResponse.statusCode,
                message: httpResponse.debugDescription
            )
        }
    }
    
    
    
}
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverCodeError(statusCode: Int, message: String?)
    case notDataFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Неверный URL адрес"
        case .invalidResponse: return "Некорректный ответ сервера"
        case .serverCodeError(let statusCode, let message): return "Ошибка сервера (\(statusCode)): \(message ?? "нет описания")"
        case .notDataFound: return "Данные не найдены"
        }
    }
}
