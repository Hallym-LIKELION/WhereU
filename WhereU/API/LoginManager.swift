//
//  LoginManager.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation

class LoginManager: APIManagerType {
    
    static let shared = LoginManager()
    
    private init() {}
    
    func fetchUser(parameters: [String: Any], completion: @escaping (User?) -> Void ){
        // ✅ paramters 를 JSON 으로 encode.
        let endPoint = "\(Constants.BASE_URL)api/user/check"
        
        let requestBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        guard let url = URL(string: endPoint) else {
            print("Error: cannot create URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // ✅ request body 추가
        request.httpBody = requestBody

        let defaultSession = URLSession(configuration: .default)

        defaultSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: error calling POST - \(String(describing: error))")
                return
            }

            guard let data = data else {
                print("data is nil")
                return
            }

            guard let output = try? JSONDecoder().decode(User.self, from: data) else {
                completion(nil)
                return
            }

            completion(output)
        }.resume()
        
        
    }
    
}
