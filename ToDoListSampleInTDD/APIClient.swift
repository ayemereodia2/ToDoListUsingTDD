//
//  APIClient.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 26/05/2021.
//

import Foundation

class APIClient {
    lazy var session:SessionProtocol = URLSession.shared
    
    func loginUser(withName:String, password:String, completion:@escaping(Token?,Error?)->()){

        let encodedUserName = withName.percentEncoding
        let encodedPassword = password.percentEncoding
        
        let query = "username=\(encodedUserName)&password=\(encodedPassword)"
        
        guard let url = URL(string: "https://awesometodos.com/login?\(query)") else {
            fatalError()
        }
       _ = session.dataTask(with: url){(data, response, error) in 
        
        guard let data = data else {
            completion(nil, WebServiceError.DataEmptyError)
            return
        }
        print(data)
        do {
            let dataValue = try JSONDecoder().decode(Token.self, from: data)
            completion(dataValue, nil)
        }catch let error {
            completion(nil, error)
        }
            
       }.resume()
    }
}
extension URLSession : SessionProtocol {}


protocol SessionProtocol {
    
    func dataTask(with url:URL, completionHandler:@escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask 
}

extension String {
    
    var percentEncoding:String {
        
        let allowedCharacters = CharacterSet(charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        return encodedString
        
    }
}

enum WebServiceError : Error {
    case DataEmptyError
}
