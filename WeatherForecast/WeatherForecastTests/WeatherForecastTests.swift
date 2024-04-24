//
//  WeatherForecastTests.swift
//  WeatherForecastTests
//
//  Created by Hong yujin on 4/19/24.
//

//import XCTest
//
//final class WeatherForecastTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}

import XCTest
@testable import WeatherForecast

final class TempFormatterTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_temperatureFormat() {
        let formatter: TempFormatter = .init()
     
        let mainInfo: MainInfo = MainInfo(temp: 5.01,
                                          feelsLike: 3.55,
                                          tempMin: 5.01,
                                          tempMax: 6.24,
                                          pressure: 1023.0,
                                          seaLevel: 1023.0,
                                          grndLevel: 1016.0,
                                          humidity: 87.0,
                                          pop: 0.0)
        let weather: Weather = Weather(id: 804,
                                       main: "Clouds",
                                       description: "overcast clouds",
                                       icon: "04d")
        let info: WeatherForecastInfo = WeatherForecastInfo(dt: TimeInterval(),
                                                            main: mainInfo,
                                                            weather: weather,
                                                            dtTxt: "2024-01-18 06:00:00")
        let tempUnit: TempUnit = .metric
        let formatString = formatter.temperatureFormat(info: info,
                                                       tempUnit: tempUnit)
         
         XCTAssertEqual(formatString, "5.01℃")
    }
}
