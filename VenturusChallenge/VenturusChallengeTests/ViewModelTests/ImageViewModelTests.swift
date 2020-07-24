//
//  ImageViewModelTests.swift
//  VenturusChallengeTests
//
//  Created by Ruyther on 23/07/20.
//  Copyright © 2020 ruyther. All rights reserved.
//

import XCTest
@testable import VenturusChallenge

class ImageViewModelTests: XCTestCase {
    
    let sessionSuccess = MockURLSession()
    
    var viewModel: ImageViewModel!
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

    func testReceiveImagesListAndDecode() {
        viewModel = ImageViewModel(httpManager: httpMockDecodingSuccess)
        
        viewModel.getImages { result in
            switch result {
            case .failure(let error):
                XCTFail("TestReceiveImageListAndDecode failed, error: \(error)")
            case .success(let data):
                XCTAssertNotNil(data)
            }
        }
    }
    
    func testReceiveImagesListAndNotDecode() {
        viewModel = ImageViewModel(httpManager: httpMockDecodingError)
        
        viewModel.getImages { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success:
                XCTFail("TestReceiveImagesListAndNotDecode failed")
            }
        }
    }
    
    func testReceiveEventListAndReturnFailure() {
        viewModel = ImageViewModel(httpManager: httpMockErrorReturn)
        
        viewModel.getImages { result in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success:
                XCTFail("TestReceiveEventListAndReturnFailure failed")
            }
        }
    }
}
