import XCTest

@testable import DownwardSpiral

class DownwardSpiralTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testInit_DataSimulator() {
        let data = dsDataSimulator()
        XCTAssertNotNil(data)
    }
    
    func testInit_DataSimulatorWithDataFromFile() {
        let data = dsDataSimulator(fileName: "dsRawData", fileType: "json")
        XCTAssert(data.getData().count == 3328)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
