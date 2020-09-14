//
//  HomeViewModelTests.swift
//  jamie_chu_nikeTests
//
//  Created by Jamie Chu on 9/13/20.
//  Copyright © 2020 Jamie Chu. All rights reserved.
//

import XCTest
import Nike_Network

class HomeViewModelTests: XCTestCase {
    
    func test_init_hasEmptyAlbumCellViewModel() {
        // GIVEN
        let (sut, _) = makeSUT()
        //THEN
        XCTAssert(sut.albumCellModels.value.isEmpty)
    }
    
    
    func test_startOnce_invokesFetcherOnce_returnsModelsOnSuccess() {
        // GIVEN
        let (sut, _) = makeSUT()
        XCTAssert(sut.albumCellModels.value.isEmpty)
        
        // WHEN
        sut.start()
        
        // THEN
        XCTAssert(!sut.albumCellModels.value.isEmpty)
        
    }
    
    func test_startOnce_withUnsuccessfulBlockCalled_callsDelegatesErrorMethodOnce() {
        // GIVEN
        let (sut, spy) = makeSUT(isSuccessful: false)
        XCTAssert(sut.albumCellModels.value.isEmpty)

        sut.start()
        
        XCTAssert(spy._errorsCache.count == 1)
    }
    
    // MARK: - Helpers
        
    private func makeSUT(isSuccessful: Bool = true) -> (HomeViewModel, HomeViewModelDelegateSpy) {
        let someDelegate = HomeViewModelDelegateSpy()
        return (
            HomeViewModel(
                recordsfetcher: FakeFetcher(isSuccessful: isSuccessful),
                delegate: someDelegate
            ),
            someDelegate
        )
    }
        
    private class HomeViewModelDelegateSpy: HomeViewModelDelegate {
        private(set) var _errorsCache: [Error] = []
        
        // MARK: - HomeViewModelDelegate
        func homeViewModel(_ homeModel: HomeViewModel, fetchingDidFailWith error: Error) {
            _errorsCache.append(error)
        }
    }
    
    private struct FakeFetcher: ItunesRecordFetcher {
        
        let isSuccessful: Bool
        
        func fetchDefaultRaw(router: URLRequestableHTTPRouter, completion: @escaping (Result<ItunesMonolith, Error>) -> Void) {

            let returnValue: Result<ItunesMonolith, Error> = isSuccessful
                ? .success(mockMonolith())
                : .failure(anySwiftError())

            completion(returnValue)
        }
        
        private func mockMonolith() -> ItunesMonolith  {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(nikeDateFormatter)
            let value = try! decoder.decode(ItunesMonolith.self, from: privateStub)
            return value
        }
        
        private let nikeDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
        }()
    }

}

protocol HomeViewModelDelegate: class {
    func homeViewModel(_ homeModel: HomeViewModel, fetchingDidFailWith error: Error)
}

final class HomeViewModel {
    
    // MARK: - Private API
    private let recordsfetcher: ItunesRecordFetcher
    private weak var delegate: HomeViewModelDelegate?
    
    // MARK: - Init
    
    init(recordsfetcher: ItunesRecordFetcher, delegate: HomeViewModelDelegate) {
        self.recordsfetcher = recordsfetcher
        self.delegate = delegate
    }

    // MARK: - Public API
    private(set) var albumCellModels: Box<[AlbumCellViewModel]> = Box([])

    func start() {
        recordsfetcher.fetchDefaultRaw(router: ITunesRouter.nikeDefault) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.delegate?.homeViewModel(self, fetchingDidFailWith: error)
            case .success(let rawModel):
                let cellModels = rawModel.feed.results.map {
                    AlbumCellViewModelImpl(
                        nameOfAlbum: $0.artistID,
                        artist: $0.artistName,
                        thumbnailImage: $0.artistURL
                    )
                }
                
                self.albumCellModels.value = cellModels
            }
        }
    }
}

//    Each cell should display the name of the album, the artist, and the album art (thumbnail image).
protocol AlbumCellViewModel {
    var nameOfAlbum: Box<String> { get }
    var artist: Box<String> { get }
    var thumbnailImage: Box<URL> { get }
}

struct AlbumCellViewModelImpl: AlbumCellViewModel {
    let nameOfAlbum: Box<String>
    let artist: Box<String>
    let thumbnailImage: Box<URL>
    
    init(nameOfAlbum: String, artist: String, thumbnailImage: URL) {
        self.nameOfAlbum = Box(nameOfAlbum)
        self.artist = Box(artist)
        self.thumbnailImage = Box(thumbnailImage)
    }
}

final class Box<T> {
    typealias Listener = (T) -> Void
    
    private var listener: Listener?
    
    // MARK: - Public API
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(listener: Listener? = nil) {
        self.listener = listener
        listener?(value)
    }
    
    // MARK: - Init
    
    init(_ value: T) {
        self.value = value
    }
    
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
