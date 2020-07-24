//
//  ImageCollectionViewModelTests.swift
//  VenturusChallengeTests
//
//  Created by Ruyther on 23/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import XCTest
@testable import VenturusChallenge

class ImageCollectionViewModelTests: XCTestCase {
    
    let sessionSuccess = MockURLSession()
    
    var viewModel: ImageCollectionViewModel!
    var httpMockDecodingSuccess: HTTPManagerMockSuccessReturnOne!
    var httpMockDecodingError: HTTPManagerMockSuccessReturnTwo!
    var httpMockErrorReturn: HTTPManagerMockErrorReturn!

    override func setUp() {
        super.setUp()

        httpMockDecodingSuccess = HTTPManagerMockSuccessReturnOne(session: sessionSuccess)
        httpMockDecodingError = HTTPManagerMockSuccessReturnTwo(session: sessionSuccess)
        httpMockErrorReturn = HTTPManagerMockErrorReturn(session: sessionSuccess)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testReceiveDataAndDecode() {
        viewModel = ImageCollectionViewModel(httpManager: httpMockDecodingSuccess)
        
        viewModel.getData(from: "") { result in
            switch result {
            case .failure(let error):
                XCTFail("TestReceiveDataListAndDecode failed, error: \(error)")
            case .success(let data):
                XCTAssertNotNil(data)
            }
        }
    }
    
    func testReceiveDataInvalidURL() {
        viewModel = ImageCollectionViewModel(httpManager: httpMockDecodingError)
        
        viewModel.getData(from: "") { result in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription == HTTPError.invalidURL.localizedDescription)
            case .success:
                XCTFail("TestReceiveDataListAndNotDecode failed")
            }
        }
    }
    
    func testReceiveDataAndReturnFailure() {
        viewModel = ImageCollectionViewModel(httpManager: httpMockErrorReturn)
        
        viewModel.getData(from: "") { result in
            switch result {
            case .failure(let error):
                XCTAssertTrue(error.localizedDescription == "The operation couldn’t be completed. (Test error 404.)")
            case .success:
                XCTFail("TestReceiveEventListAndReturnFailure failed")
            }
        }
    }
}
