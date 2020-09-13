//
//  ItunesNetworkAPITests.swift
//  Nike_NetworkTests
//
//  Created by Jamie Chu on 9/12/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
@testable import Nike_Network
class ItunesNetworkAPITests: XCTestCase {

    func test_iTunesMonolithDecoding() {
        // GIVEN
        let sut = makeSUT()
        let myExpectation = expectation(description: #function)
        
        
        // WHEN
        var capturedMonolithInstance: ItunesMonolith?
        
        sut.fetchDefaultRaw { result in
            defer { myExpectation.fulfill() }
            
            switch result {
            case .failure:
                XCTFail()
            case .success(let actualMonolithInstance):
                capturedMonolithInstance = actualMonolithInstance
            }
        }
        
        wait(for: [myExpectation], timeout: 0.1)
        
        XCTAssertEqual(capturedMonolithInstance, expectedMonolith())
        
    }
    
    func test_apiReturnsOnMainThread() {
        
    }
        
    // MARK: - Helpers
    
    private func makeSUT(source: Source = .local) -> ItunesRecordFetcher {
        switch source {
        case .local:
            return LocallyStubbedItunesAPI(data: privateStub)
        case .remote:
            return RemoteItunesAPI(session: .shared)
        }
    }
    
    private class RemoteItunesAPI: ItunesRecordFetcher {
        
        private let session: URLSession
        init(session: URLSession) {
            self.session = session
        }
        
        private static let nikeDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
        }()
        
        private static let nikeItunesJsonDecoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(nikeDateFormatter)
            return decoder
        }()

        
        // MARK: - ItunesRecordFetcher
        
        func fetchDefaultRaw(completion: @escaping (Result<ItunesMonolith, Error>) -> Void) {
            do {
                let request = try ITunesRouter.nikeDefault.asURLRequest()
                session.dataTask(with: request) {
                    
                    let processor: DecodableResultProcessor<ItunesMonolith> = DecodableResultProcessor(
                        rawResponse: ($0, $1, $2),
                        decoder: Self.nikeItunesJsonDecoder
                    )
                    
                    Self.dispatch { completion(processor.process()) }
                }.resume()
            } catch {
                completion(.failure(error))
            }
        }
        
        private static func dispatch(block: @escaping ()-> Void) {
            DispatchQueue.main.async(execute: block)
        }
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
            self.processor = DecodableResultProcessor(
                rawResponse: (data, validHTTPURLResponse(), nil),
                decoder: decoder
            )
        }
        
        func fetchDefaultRaw(completion: @escaping (Result<ItunesMonolith, Error>) -> Void) {
            assert(Thread.isMainThread)
            completion(processor.process())
        }
    }
    
    private enum Source {
        case local
        case remote
    }
        
    // TODO: - remove force unwraps on dates
    private func expectedMonolith() -> ItunesMonolith {
        let updatedDate = LocallyStubbedItunesAPI.nikeDateFormatter.date(from: "2020-09-12T01:49:37.000-07:00") ?? Date()
        return .init(
            feed: .init(
                title: "Top Albums",
                id: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/3/explicit.json",
                author: .init(
                    name: "iTunes Store",
                    uri: URL(string: "http://wwww.apple.com/us/itunes/")!
                ),
                links: [
                    .init(
                        linkSelf: URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/3/explicit.json"),
                        alternate: nil
                    ),
                    .init(
                        linkSelf: nil,
                        alternate: URL(string:  "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?genreId=34&popId=82&app=music")
                    )
                ],
                copyright: "Copyright © 2018 Apple Inc. All rights reserved.",
                country: "us",
                icon: URL(string: "http://itunes.apple.com/favicon.ico")!,
                updated: updatedDate, // TODO: -- this needs a special date decoder
                results: [
                    .init(
                        artistName: "YoungBoy Never Broke Again",
                        id: "1530122403",
                        releaseDate: "2020-09-11",
                        name: "Top",
                        kind: .album,
                        copyright: "Never Broke Again, LLC / Atlantic Records, ℗ 2020 Artist Partner Group, Inc.",
                        artistID: "1168822104",
                        contentAdvisoryRating: "Explicit",
                        artistURL: URL(string: "https://music.apple.com/us/artist/youngboy-never-broke-again/1168822104?app=music")!,
                        artworkUrl100: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/13/d6/e3/13d6e3ac-7a38-c6c3-6566-e027f3735426/075679802378.jpg/200x200bb.png")!,
                        genres: [
                            .init(
                                genreID: "18",
                                name: .hipHopRap,
                                url: URL(string: "https://itunes.apple.com/us/genre/id18")!
                            ),
                            .init(
                                genreID: "34",
                                name: .music,
                                url: URL(string: "https://itunes.apple.com/us/genre/id34")!
                            )
                        ],
                        url: URL(string: "https://music.apple.com/us/album/top/1530122403?app=music")!
                    ),
                    .init(
                        artistName: "Big Sean",
                        id: "1530247672",
                        releaseDate: "2020-09-04",
                        name: "Detroit 2",
                        kind: .album,
                        copyright: "℗ 2020 Getting Out Our Dreams, Inc./Def Jam Recordings, a division of UMG Recordings, Inc.",
                        artistID: "302533564",
                        contentAdvisoryRating: "Explicit",
                        artistURL: URL(string: "https://music.apple.com/us/artist/big-sean/302533564?app=music")!,
                        artworkUrl100: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/46/b2/f1/46b2f125-58b9-e503-ad81-5174ffd06f3b/20UMGIM72128.rgb.jpg/200x200bb.png")!,
                        genres: [
                            .init(
                                genreID: "18",
                                name: .hipHopRap,
                                url: URL(string: "https://itunes.apple.com/us/genre/id18")!
                            ),
                            .init(
                                genreID: "34",
                                name: .music,
                                url: URL(string: "https://itunes.apple.com/us/genre/id34")!
                            )
                        ],
                        url: URL(string: "https://music.apple.com/us/album/detroit-2/1530247672?app=music")!
                    ),
                    .init(
                        artistName: "Pop Smoke",
                        id: "1521889004",
                        releaseDate: "2020-07-03",
                        name: "Shoot for the Stars Aim for the Moon",
                        kind: .album,
                        copyright: "Victor Victor Worldwide; ℗ 2020 Republic Records, a division of UMG Recordings, Inc. & Victor Victor Worldwide",
                        artistID: "1450601383",
                        contentAdvisoryRating: "Explicit",
                        artistURL: URL(string: "https://music.apple.com/us/artist/pop-smoke/1450601383?app=music")!,
                        artworkUrl100: URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/17/6d/e0/176de0c9-42a6-8741-9d22-6aae00094e1d/20UMGIM55833.rgb.jpg/200x200bb.png")!,
                        genres: [
                            .init(
                                genreID: "18",
                                name: .hipHopRap,
                                url: URL(string: "https://itunes.apple.com/us/genre/id18")!
                            ),
                            .init(
                                genreID: "34",
                                name: .music,
                                url: URL(string: "https://itunes.apple.com/us/genre/id34")!
                            ),
                        ],
                        url: URL(string: "https://music.apple.com/us/album/shoot-for-the-stars-aim-for-the-moon/1521889004?app=music")!
                    ),
                ]
            )
        )
    }

}

protocol ItunesRecordFetcher {
    func fetchDefaultRaw(completion: @escaping (Result<ItunesMonolith, Error>)->Void)
}

private let privateStub: Data = """
{
  "feed": {
    "title": "Top Albums",
    "id": "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/3/explicit.json",
    "author": {
      "name": "iTunes Store",
      "uri": "http://wwww.apple.com/us/itunes/"
    },
    "links": [
      {
        "self": "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/3/explicit.json"
      },
      {
        "alternate": "https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?genreId=34&popId=82&app=music"
      }
    ],
    "copyright": "Copyright © 2018 Apple Inc. All rights reserved.",
    "country": "us",
    "icon": "http://itunes.apple.com/favicon.ico",
    "updated": "2020-09-12T01:49:37.000-07:00",
    "results": [
      {
        "artistName": "YoungBoy Never Broke Again",
        "id": "1530122403",
        "releaseDate": "2020-09-11",
        "name": "Top",
        "kind": "album",
        "copyright": "Never Broke Again, LLC / Atlantic Records, ℗ 2020 Artist Partner Group, Inc.",
        "artistId": "1168822104",
        "contentAdvisoryRating": "Explicit",
        "artistUrl": "https://music.apple.com/us/artist/youngboy-never-broke-again/1168822104?app=music",
        "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/13/d6/e3/13d6e3ac-7a38-c6c3-6566-e027f3735426/075679802378.jpg/200x200bb.png",
        "genres": [
          {
            "genreId": "18",
            "name": "Hip-Hop/Rap",
            "url": "https://itunes.apple.com/us/genre/id18"
          },
          {
            "genreId": "34",
            "name": "Music",
            "url": "https://itunes.apple.com/us/genre/id34"
          }
        ],
        "url": "https://music.apple.com/us/album/top/1530122403?app=music"
      },
      {
        "artistName": "Big Sean",
        "id": "1530247672",
        "releaseDate": "2020-09-04",
        "name": "Detroit 2",
        "kind": "album",
        "copyright": "℗ 2020 Getting Out Our Dreams, Inc./Def Jam Recordings, a division of UMG Recordings, Inc.",
        "artistId": "302533564",
        "contentAdvisoryRating": "Explicit",
        "artistUrl": "https://music.apple.com/us/artist/big-sean/302533564?app=music",
        "artworkUrl100": "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/46/b2/f1/46b2f125-58b9-e503-ad81-5174ffd06f3b/20UMGIM72128.rgb.jpg/200x200bb.png",
        "genres": [
          {
            "genreId": "18",
            "name": "Hip-Hop/Rap",
            "url": "https://itunes.apple.com/us/genre/id18"
          },
          {
            "genreId": "34",
            "name": "Music",
            "url": "https://itunes.apple.com/us/genre/id34"
          }
        ],
        "url": "https://music.apple.com/us/album/detroit-2/1530247672?app=music"
      },
      {
        "artistName": "Pop Smoke",
        "id": "1521889004",
        "releaseDate": "2020-07-03",
        "name": "Shoot for the Stars Aim for the Moon",
        "kind": "album",
        "copyright": "Victor Victor Worldwide; ℗ 2020 Republic Records, a division of UMG Recordings, Inc. & Victor Victor Worldwide",
        "artistId": "1450601383",
        "contentAdvisoryRating": "Explicit",
        "artistUrl": "https://music.apple.com/us/artist/pop-smoke/1450601383?app=music",
        "artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Music124/v4/17/6d/e0/176de0c9-42a6-8741-9d22-6aae00094e1d/20UMGIM55833.rgb.jpg/200x200bb.png",
        "genres": [
          {
            "genreId": "18",
            "name": "Hip-Hop/Rap",
            "url": "https://itunes.apple.com/us/genre/id18"
          },
          {
            "genreId": "34",
            "name": "Music",
            "url": "https://itunes.apple.com/us/genre/id34"
          }
        ],
        "url": "https://music.apple.com/us/album/shoot-for-the-stars-aim-for-the-moon/1521889004?app=music"
      }
    ]
  }
}
""".data(using: .utf8)!

