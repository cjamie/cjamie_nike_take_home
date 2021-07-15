//
//  RemoteItunesAPITestCase.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 7/12/21.
//  Copyright © 2021 Jamie Chu. All rights reserved.
//

import XCTest
@testable import Nike_Network

struct Feed2: Codable {
    let title: String
}

class RemoteItunesAPITestCase: XCTestCase {
    func test_fetchDefaultRaw_withSessionThatCompletes_withValidEmptyFeedJSONData_shouldCompleteExpectedResult() {
        // GIVEN
        let (sut, sessionSpy) = makeSUT()

        let expectedFeed = Feed(
            title: "title",
            id: "id",
            author: .init(
                name: "authorName",
                uri: URL(string: "https://example1.com/")!
            ),
            links: [],
            copyright: "copyright",
            country: "some country",
            icon: URL(string: "https://example2.com/")!,
            updated: LocallyStubbedItunesAPI.nikeDateFormatter.date(from: "2020-09-12T01:49:37.000-07:00")!,
            results: [])


        // WHEN
        expect(sut,
               toCompleteExpectedFeed: .init(feed: expectedFeed),
            when: {
                sessionSpy.completeDatataskWith(
                    data: basicFeed().asData,
                    response: anySuccessfulHTTPURLResponse(),
                    error: nil
                )
            }
        )

        // THEN
    }


    private func expect(
        _ sut: ItunesRecordFetcher,
        toCompleteExpectedFeed expected: ItunesMonolith,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var captured: [ItunesMonolith] = []

        sut.fetchDefaultRaw(router: validHTTPRouter()) { result in
            switch result {
            case .failure(let error):
                XCTFail("unexpected failure \(error)", file: file, line: line)

            case .success(let instance):
                captured.append(instance)
            }
        }

        action()

        XCTAssertEqual(captured, [expected])
    }

    func validEmptyJsonData() -> Data {
        .init()
    }

    private func makeSUT() -> (ItunesRecordFetcher, SessionSpy) {
        let sessionSpy = SessionSpy()

        let sut = RemoteItunesAPI(session: sessionSpy)

        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(sessionSpy)

        return (sut, sessionSpy)
    }

    private func anyFeed() -> Feed {
        .init(
            title: anyString(),
            id: anyString(),
            author: .init(name: anyString(), uri: anyURL()),
            links: [],
            copyright: anyString(),
            country: anyString(),
            icon: anyURL(),
            updated: Date(),
            results: []
        )
    }
}

class SessionSpy: Session {
    private(set) var calledDataTask: [DatataskCall] = []
    private var returnStub = Stub(dataTask: TaskSpy())

    private struct Stub {
        let dataTask: Task
    }

    struct DatataskCall {
        let request: URLRequest
        let completionHandler: (Data?, URLResponse?, Error?) -> Void
    }

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> Task {
        calledDataTask.append(.init(request: request, completionHandler: completionHandler))

        return returnStub.dataTask
    }

    func completeDatataskWith(data: Data?, response: URLResponse?, error: Error?, at index: Int = 0) {
        calledDataTask[0].completionHandler(data, response, error)
    }
}

class TaskSpy: Task {
    private(set) var calledResume = 0

    func resume() {
        calledResume += 1
    }
}

struct FakeURLRequestableHTTPRouter: URLRequestableHTTPRouter {
    let method: String
    let host: String
    let scheme: String
    let path: String
    let parameters: [String: String]
    let additionalHttpHeaders: [String: String]
}

func validHTTPRouter() -> URLRequestableHTTPRouter {
    FakeURLRequestableHTTPRouter(
        method: "GET",
        host: "example.com",
        scheme: "https",
        path: "",
        parameters: [:],
        additionalHttpHeaders: [:])
}

func anyHTTPRouter() -> FakeURLRequestableHTTPRouter {
    .init(
        method: anyString(),
        host: anyString(),
        scheme: anyString(),
        path: anyString(),
        parameters: [:],
        additionalHttpHeaders: [anyString(): anyString()]
    )
}

    func basicFeed() -> (asString: String, asData: Data) {
        let stubString = """
        {
          "feed": {
            "title": "title",
            "id": "id",
            "author": {
              "name": "authorName",
              "uri": "https://example1.com/"
            },
            "links": [],
            "copyright": "copyright",
            "country": "some country",
            "icon": "https://example2.com/",
            "updated": "2020-09-12T01:49:37.000-07:00",
            "results": []
          }
        }
        """

        //    .data(using: .utf8)
        return (stubString, stubString.data(using: .utf8)!)
    }


private class LocallyStubbedItunesAPI: ItunesRecordFetcher {

    private let decoder: JSONDecoder
    private let data: Data
    let processor: DecodableResultProcessor<ItunesMonolith>

    static let nikeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    init(data: Data) {
        self.data = data

        self.decoder = {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(Self.nikeDateFormatter)
            return jsonDecoder
        }()
        self.processor = DecodableResultProcessor(decoder: .init())
    }

    func fetchDefaultRaw(router: URLRequestableHTTPRouter, completion: @escaping (Result<ItunesMonolith, Error>) -> Void) {
        assert(Thread.isMainThread)
        completion(processor.process(rawResponse: (nil, nil, nil)))
    }
}
