//
//  APIClientTests.swift
//  ToDoListSampleInTDDTests
//
//  Created by Ayemere  Odia  on 26/05/2021.
//

import XCTest
@testable import ToDoListSampleInTDD

class APIClientTests: XCTestCase {
    
    var sut:APIClient!
    var mockUrlSession:MockUrlSession!
    
    override func setUp() {
        super.setUp()
         sut = APIClient()
         mockUrlSession = MockUrlSession(data: nil, urlResponse: nil, responseError: nil)
    }
    
    func test_Login_UsesExpected_Host(){
        
        sut.session = mockUrlSession
        
        let completion = {(token:Token?, error:Error?) in }
        sut.loginUser(withName:"dasdom", password:"1234", completion:completion)
        
        guard let url = mockUrlSession.url else {
            XCTFail()
            return
        }
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        XCTAssertEqual(mockUrlSession.urlComponent?.host, "awesometodos.com")
        
    }
    
    
    func test_Login_UsesExpected_Path(){
        
        sut.session = mockUrlSession
        
        let completion = {(token:Token?, error:Error?) in }
        sut.loginUser(withName:"dasdom", password:"1234", completion:completion)
       
        XCTAssertEqual(mockUrlSession.urlComponent?.path, "/login")
        
    }
    
    
    func test_Login_UsesExpected_Query(){
        
        sut.session = mockUrlSession
        
        let completion = {(token:Token?, error:Error?) in }
        
        sut.loginUser(withName:"dasdöm", password:"%&34", completion:completion)
        
        guard let _ = mockUrlSession.url else {
            XCTFail()
            return
        }
       
//        XCTAssertEqual(mockUrlSession.urlComponent?.query, "username=dasdom&password=1234")
        
        XCTAssertEqual(mockUrlSession.urlComponent?.percentEncodedQuery, "username=dasd%C3%B6m&password=%25%2634")
    }
    
    func test_Login_WhenSuccessful_Creates_Toke() {
        let jsonData = "{\"id\": \"1234567890\"}".data(using: .utf8)
        mockUrlSession = MockUrlSession(data: jsonData, urlResponse: nil, responseError: nil)
        sut.session = mockUrlSession
        let tokenExpectation = expectation(description: "Token")
        var caughtToken:Token? = nil
        sut.loginUser(withName: "Foo", password: "Bar"){ token, _ in 
            caughtToken = token
            tokenExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1){_ in 
            XCTAssertEqual(caughtToken?.id, "1234567890")
        }
        
    }
    
    func test_Login_WhenJsonIsInvalid_ReturnsError() {
        mockUrlSession = MockUrlSession(data: Data(), urlResponse: nil, responseError: nil)
        sut.session = mockUrlSession
        let errorExpectation = expectation(description: "Error")
        var caughtError:Error?
        sut.loginUser(withName: "Foo", password: "Bar"){(token, error) in 
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1){ _ in 
            XCTAssertNotNil(caughtError)
        }
    }
    
    func test_Login_WhenDataIs_Nil_ReturnsError() {
        mockUrlSession = MockUrlSession(data: nil, urlResponse: nil, responseError: nil)
        sut.session = mockUrlSession
        let errorExpectation = expectation(description: "Error")
        var caughtError:Error?
        sut.loginUser(withName: "Foo", password: "Bar"){(token, error) in 
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1){ _ in 
            XCTAssertNotNil(caughtError)
        }
    }
    
    func test_Login_WhenResponseHasError_ReturnsError() {
        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
        let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)
        mockUrlSession = MockUrlSession(data: jsonData, urlResponse: nil, responseError: error)
        sut.session = mockUrlSession
        let errorExpectation = expectation(description: "Error")
        var caughtError:Error?
        sut.loginUser(withName: "Foo", password: "Bar"){(token, error) in 
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1){ _ in 
            XCTAssertNotNil(caughtError)
        }
    }
}

extension APIClientTests {
    
    class MockUrlSession:SessionProtocol {
        var url:URL?
        private let  dataTask:MockTask
        
        init(data:Data?, urlResponse:URLResponse?, responseError:Error?) {
            dataTask = MockTask(data: data, response: urlResponse, error: responseError)
        }
        
        func dataTask(with url:URL, completionHandler:@escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            dataTask.completionHandler = completionHandler
            return dataTask
        }
        
        var urlComponent:URLComponents? {
            guard let url = url else {
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
    }
    
    class MockTask: URLSessionDataTask {
       
        private let data:Data?
        private let urlResponse:URLResponse?
        private let resonseError:Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler:CompletionHandler?
        
        init(data:Data?, response:URLResponse?, error:Error?) {
            self.data = data
            self.urlResponse = response
            self.resonseError = error
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.resonseError)
            }
        }
        
        
    }
}



