require('colors');
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
chai.should();
//var assert = chai.assert()
var wd;
try {
    wd = require('wd');
} catch (err) {
    wd = require('../../lib/main');
}

// enables chai assertion chaining
chaiAsPromised.transferPromiseness = wd.transferPromiseness;

var desired = {
    "appium-version": "1.0",
    platformName: "iOS",
    platformVersion: "9.3",
    deviceName: "iPhone 6s Plus",
    app: "/Users/wangchaojs02/workspace/feature/TableViewDemo/App/TableViewDemo.app",
};

describe('hooks', function() {
    this.timeout(10000); //10s
    var browser;
    var itemCount;

    before(function(done) {
        // runs before all tests in this block
        browser = wd.promiseChainRemote("127.0.0.1", 4723);
        //browser._debugPromise();
        browser.on('status', function(info) {
            // console.log(info);
        });
        browser.on('command', function(meth, path, data) {
            // console.log(' > ' + meth, path, data || '');
        });
        browser.init(desired).nodeify(done);
    });

    after(function(done) {
        // runs after all tests in this block
        browser.quit().nodeify(done);
    });

    beforeEach(function(done) {
        // runs before each test in this block
        browser.elementsByClassName("UIATableCell")
            .then(function(elements) {
                itemCount = elements.length
            }).nodeify(done);
    });

    afterEach(function(done) {
        // runs after each test in this block
        done()
    });

    // test cases
    it("a case", function(done) {
        // console.log(' > ' + done);

        browser
            .elementByName("+").click()
            .sleep(1 * 500)
            .elementsByClassName("UIATableCell")
            .then(function(elements) {
                elements.length.should.equal(itemCount + 1)
            })
            .nodeify(done)
    })
});
