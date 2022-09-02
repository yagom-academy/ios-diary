import XCTest
@testable import Diary

class DiaryTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_GET_메서드_동작확인() {
        // given
        let expectation = XCTestExpectation(description: "비동기테스트")
        let session = MockSession()
        let request = OpenWeatherRequest(method: .get, baseURL: URLHost.openWeather.url, query: [URLQuery.latitude.text: "37.785834", URLQuery.longitude.text: "-122.406417", URLQuery.apiKey.text: APIkey.key], path: URLAdditionalPath.data.value)
        var weatherMain: String?
        
        session.dataTask(with: request) { result in
            switch result {
            case . success(let responseData):
                let weatherData = try? JSONDecoder().decode(WeatherData.self, from: responseData)
                weatherMain = weatherData?.weather[0].main
                expectation.fulfill()
            case .failure(let error):
                print(error)
                return
            }
        }
        
        wait(for: [expectation], timeout: 3)
        
        // when
        let result = "Clouds"
        
        // then
        XCTAssertEqual(weatherMain, result)
    }
}
