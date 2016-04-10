require('colors');
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
chai.should();

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
    this.timeout(300000); //30s

    var browser;
    var itemCount;
    before(function() {
        // runs before all tests in this block
        browser = wd.promiseChainRemote("127.0.0.1", 4723);
        //browser._debugPromise();
        browser.on('command', function(eventType, command, response) {
            console.log(' > ' + eventType.cyan, command, (response || '').grey);
        });
        browser.on('http', function(meth, path, data) {
            console.log(' > ' + meth.magenta, path, (data || '').grey);
        });
        return browser.init(desired).then(function() {});
    });

    after(function() {
        // runs after all tests in this block
        browser.quit();
    });

    beforeEach(function() {
        return browser.elementsByClassName("UIATableCell")
            .then(function(elements) {
                itemCount = elements.length
            })
    });

    afterEach(function() {
        // runs after each test in this block
    });

    // test cases
    it("a case", function() {
        return browser
            .elementByName("+").click()
            .sleep(1 * 500)
            .elementsByClassName("UIATableCell")
            .then(function(elements) {
                elements.length.should.equal(itemCount + 1)
            })
    });

    it('111', function() {
        
    });
});
