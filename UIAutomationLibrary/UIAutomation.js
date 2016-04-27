/**
 * Created by wangchaojs02 on 16/4/27.
 */
var UIA_DEVICE_ORIENTATION;
(function (UIA_DEVICE_ORIENTATION) {
    UIA_DEVICE_ORIENTATION[UIA_DEVICE_ORIENTATION["UIA_DEVICE_ORIENTATION_UNKNOWN"] = 1] = "UIA_DEVICE_ORIENTATION_UNKNOWN";
    UIA_DEVICE_ORIENTATION[UIA_DEVICE_ORIENTATION["UIA_DEVICE_ORIENTATION_PORTRAIT"] = 2] = "UIA_DEVICE_ORIENTATION_PORTRAIT";
    UIA_DEVICE_ORIENTATION[UIA_DEVICE_ORIENTATION["UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN"] = 3] = "UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN";
    UIA_DEVICE_ORIENTATION[UIA_DEVICE_ORIENTATION["UIA_DEVICE_ORIENTATION_LANDSCAPELEFT"] = 4] = "UIA_DEVICE_ORIENTATION_LANDSCAPELEFT";
    UIA_DEVICE_ORIENTATION[UIA_DEVICE_ORIENTATION["UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT"] = 5] = "UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT";
    UIA_DEVICE_ORIENTATION[UIA_DEVICE_ORIENTATION["UIA_DEVICE_ORIENTATION_FACEUP"] = 6] = "UIA_DEVICE_ORIENTATION_FACEUP";
    UIA_DEVICE_ORIENTATION[UIA_DEVICE_ORIENTATION["UIA_DEVICE_ORIENTATION_FACEDOWN"] = 7] = "UIA_DEVICE_ORIENTATION_FACEDOWN";
})(UIA_DEVICE_ORIENTATION || (UIA_DEVICE_ORIENTATION = {}));
var UIALogger = (function () {
    function UIALogger() {
    }
    UIALogger.prototype.logFail = function (message) { };
    UIALogger.prototype.logIssue = function (message) { };
    UIALogger.prototype.logPass = function (message) { };
    UIALogger.prototype.logStart = function (message) { };
    UIALogger.prototype.logDebug = function (message) { };
    UIALogger.prototype.logError = function (message) { };
    UIALogger.prototype.logMessage = function (message) { };
    UIALogger.prototype.logWarning = function (message) { };
    return UIALogger;
}());
var UIAHost = (function () {
    function UIAHost() {
    }
    UIAHost.prototype.performTaskWithPathArgumentsTimeout = function (path, args, timeout) { };
    return UIAHost;
}());
var Coordinate = (function () {
    function Coordinate(latitude, longitude) {
    }
    return Coordinate;
}());
var LocationOptions = (function () {
    function LocationOptions() {
    }
    return LocationOptions;
}());
var UIATarget = (function () {
    function UIATarget() {
    }
    UIATarget.prototype.host = function () { };
    UIATarget.prototype.localTarget = function () { };
    UIATarget.prototype.deactivateApp = function (duration) { };
    UIATarget.prototype.frontMostApp = function () { };
    UIATarget.prototype.model = function () { };
    UIATarget.prototype.name = function () { };
    UIATarget.prototype.rect = function () { };
    UIATarget.prototype.systemName = function () { };
    UIATarget.prototype.systemVersion = function () { };
    UIATarget.prototype.deviceOrientation = function () { };
    UIATarget.prototype.setDeviceOrientation = function (deviceOrientation) { };
    UIATarget.prototype.setLocation = function (coordinate) { };
    UIATarget.prototype.setLocationWithOptions = function (coordinate, options) { };
    UIATarget.prototype.holdVolumeDown = function (duration) { };
    UIATarget.prototype.holdVolumeUp = function (duration) { };
    UIATarget.prototype.lockForDuration = function (duration) { };
    UIATarget.prototype.lock = function () { };
    UIATarget.prototype.shake = function () { };
    UIATarget.prototype.unlock = function () { };
    UIATarget.prototype.dragFromToForDuration = function (rect, rect, duration) {
        if (rect === void 0) { rect =  | point; }
        if (rect === void 0) { rect =  | point; }
    };
    UIATarget.prototype.doubleTap = function (rect) {
        if (rect === void 0) { rect =  | point | UIAElement; }
    };
    UIATarget.prototype.flickFromTo = function (rect, rect) {
        if (rect === void 0) { rect =  | point; }
        if (rect === void 0) { rect =  | point; }
    };
    UIATarget.prototype.pinchCloseFromToForDuration = function (rect, rect, duration) {
        if (rect === void 0) { rect =  | point; }
        if (rect === void 0) { rect =  | point; }
    };
    UIATarget.prototype.pinchOpenFromToForDuration = function (rect, rect, duration) {
        if (rect === void 0) { rect =  | point; }
        if (rect === void 0) { rect =  | point; }
    };
    UIATarget.prototype.rotateWithOptions = function (_a, _b) {
        var  = _a.x,  = _a.y;
        var  = _b.duration,  = _b.radius,  = _b.rotation,  = _b.touchCount;
    };
    UIATarget.prototype.tap = function (rect) {
        if (rect === void 0) { rect =  | point | UIAElement; }
    };
    UIATarget.prototype.tapWithOptions = function (rect, _a) {
        if (rect === void 0) { rect =  | point | UIAElement; }
        var  = _a.tapCount,  = _a.touchCount,  = _a.duration;
    };
    UIATarget.prototype.touchAndHold = function (rect, duration) {
        if (rect === void 0) { rect =  | point | UIAElement; }
    };
    UIATarget.prototype.captureRectWithName = function (rect, imageName) { };
    UIATarget.prototype.captureScreenWithName = function (imageName) { };
    UIATarget.prototype.popTimeout = function () { };
    UIATarget.prototype.pushTimeout = function (timeoutValue) { };
    UIATarget.prototype.setTimeout = function (timeout) { };
    UIATarget.prototype.timeout = function () { };
    UIATarget.prototype.delay = function (timeInterval) { };
    UIATarget.prototype.onAlert = function (alert) { };
    return UIATarget;
}());
var UIAApplication = (function () {
    function UIAApplication() {
        this.UIANavigationBar = {};
    }
    UIAApplication.prototype.actionSheet = function () { };
    UIAApplication.prototype.alert = function () { };
    UIAApplication.prototype.bundleID = function () { };
    UIAApplication.prototype.editingMenu = function () { };
    UIAApplication.prototype.interfaceOrientation = function () { };
    UIAApplication.prototype.keyboard = function () { };
    UIAApplication.prototype.mainWindow = function () { };
    UIAApplication.prototype.navigationBar = ;
    UIAApplication.prototype.preferencesValueForKey = function (key) { };
    UIAApplication.prototype.setPreferencesValueForKey = function (value, key) { };
    UIAApplication.prototype.statusBar = function () { };
    UIAApplication.prototype.tabBar = function () { };
    UIAApplication.prototype.toolbar = function () { };
    UIAApplication.prototype.version = function () { };
    UIAApplication.prototype.windows = function () { };
    return UIAApplication;
}());
var UIAElement = (function () {
    function UIAElement() {
    }
    UIAElement.prototype.hitpoint = function () { };
    UIAElement.prototype.rect = function () { };
    UIAElement.prototype.activityIndicators = function () { };
    UIAElement.prototype.activityView = function () { };
    UIAElement.prototype.ancestry = function () { };
    UIAElement.prototype.buttons = function () { };
    return UIAElement;
}());
(UIAElementArray);
collectionViews();
elements();
UIAElementArray;
{ }
images();
UIAElementArray;
{ }
links();
UIAElementArray;
{ }
navigationBar();
UIAElement;
{ }
navigationBars();
UIAElementArray;
{ }
pageIndicators();
UIAElementArray;
{ }
parent();
UIAElement;
{ }
pickers();
UIAElementArray;
{ }
popover();
UIAPopover;
{ }
progressIndicators();
UIAElementArray;
{ }
scrollViews();
UIAElementArray;
{ }
searchBars();
UIAElementArray;
{ }
secureTextFields();
UIAElementArray;
{ }
segmentedControls();
UIAElementArray;
{ }
sliders();
UIAElementArray;
{ }
staticTexts();
UIAElementArray;
{ }
switches();
UIAElementArray;
{ }
tabBar();
UIAElement;
{ }
tabBars();
UIAElementArray;
{ }
tableViews();
UIAElementArray;
{ }
textFields();
UIAElementArray;
{ }
textViews();
UIAElementArray;
{ }
toolbar();
UIAElement;
{ }
toolbars();
UIAElementArray;
{ }
webViews();
UIAElementArray;
{ }
doubleTap();
{ }
dragInsideWithOptions({ touchCount: , duration: , startOffset: { x: , y:  }, endOffset: { x: , y:  } });
{ }
flickInsideWithOptions({ touchCount: , startOffset: { x: , y:  }, endOffset: { x: , y:  } });
{ }
rotateWithOptions({ centerOffset: , duration: , radius: , rotation: , touchCount:  });
{ }
scrollToVisible();
{ }
tap();
{ }
tapWithOptions({ tapCount: , touchCount: , duration: , tapOffset:  });
{ }
touchAndHold(duration, Number);
{ }
twoFingerTap();
{ }
checkIsValid();
Boolean;
{ }
hasKeyboardFocus();
Number;
{ }
isEnabled();
Number;
{ }
isValid();
Boolean;
{ }
isVisible();
Number;
{ }
waitForInvalid();
Boolean;
{ }
label();
string;
{ }
name();
string;
{ }
value();
string;
{ }
withName(name, string);
UIAElement;
{ }
withPredicate(predicateString, PredicateString);
UIAElement;
{ }
withValueForKey(value, NotTyped, key, string);
UIAElement;
{ }
logElement();
{ }
logElementTree();
{ }
var UIAElementArray = (function () {
    function UIAElementArray() {
    }
    return UIAElementArray;
}());
(Number);
length;
firstWithName(name, string);
UIAElement;
{ }
firstWithPredicate(predicateString, PredicateString);
UIAElement;
{ }
firstWithValueForKey(value, NotTyped, key, string);
UIAElement;
{ }
toArray();
Array;
{ }
withName(name, string);
UIAElementArray;
{ }
withPredicate(predicateString, PredicateString);
UIAElementArray;
{ }
withValueForKey(value, NotTyped, key, string);
UIAElementArray;
{ }
UIAElementNil;
var UIAScrollView = (function () {
    function UIAScrollView() {
    }
    UIAScrollView.prototype.scrollUp = function () { };
    UIAScrollView.prototype.scrollDown = function () { };
    UIAScrollView.prototype.scrollLeft = function () { };
    UIAScrollView.prototype.scrollRight = function () { };
    UIAScrollView.prototype.scrollToElementWithName = function (name) { };
    UIAScrollView.prototype.scrollToElementWithPredicate = function (predicateString) { };
    UIAScrollView.prototype.scrollToElementWithValueForKey = function (value, key) { };
    return UIAScrollView;
}());
var UIATableView = (function () {
    function UIATableView() {
    }
    return UIATableView;
}());
UIAScrollView;
{
    cells();
    UIAElementArray;
    { }
    groups();
    UIAElementArray;
    { }
    visibleCells();
    UIAElementArray;
    { }
}
var UIATableCell = (function () {
    function UIATableCell() {
    }
    return UIATableCell;
}());
var UIATableGroup = (function () {
    function UIATableGroup() {
    }
    return UIATableGroup;
}());
var UIACollectionView = (function () {
    function UIACollectionView() {
    }
    UIACollectionView.prototype.cells = function () { };
    UIACollectionView.prototype.visibleCells = function () { };
    return UIACollectionView;
}());
var UIAButton = (function () {
    function UIAButton() {
    }
    return UIAButton;
}());
var UIAActionSheet = (function () {
    function UIAActionSheet() {
    }
    UIAActionSheet.prototype.cancelButton = function () { };
    return UIAActionSheet;
}());
var UIAActivityIndicator = (function () {
    function UIAActivityIndicator() {
    }
    return UIAActivityIndicator;
}());
var UIAActivityView = (function () {
    function UIAActivityView() {
    }
    UIAActivityView.prototype.cancelButton = function () { };
    return UIAActivityView;
}());
var UIAAlert = (function () {
    function UIAAlert() {
    }
    UIAAlert.prototype.cancelButton = function () { };
    UIAAlert.prototype.defaultButton = function () { };
    return UIAAlert;
}());
var UIAEditingMenu = (function () {
    function UIAEditingMenu() {
    }
    return UIAEditingMenu;
}());
var UIAKey = (function () {
    function UIAKey() {
    }
    return UIAKey;
}());
var UIAKeyboard = (function () {
    function UIAKeyboard() {
    }
    UIAKeyboard.prototype.keys = function () { };
    UIAKeyboard.prototype.typeString = function (string) { };
    return UIAKeyboard;
}());
var UIALink = (function () {
    function UIALink() {
    }
    UIALink.prototype.url = function () { };
    return UIALink;
}());
var UIANavigationBar = (function () {
    function UIANavigationBar() {
    }
    UIANavigationBar.prototype.leftButton = function () { };
    UIANavigationBar.prototype.rightButton = function () { };
    return UIANavigationBar;
}());
var UIAPageIndicator = (function () {
    function UIAPageIndicator() {
    }
    UIAPageIndicator.prototype.goToNextPage = function () { };
    UIAPageIndicator.prototype.goToPreviousPage = function () { };
    UIAPageIndicator.prototype.pageCount = function () { };
    UIAPageIndicator.prototype.pageIndex = function () { };
    UIAPageIndicator.prototype.selectPage = function (index) { };
    return UIAPageIndicator;
}());
var UIAPicker = (function () {
    function UIAPicker() {
    }
    UIAPicker.prototype.wheels = function () { };
    return UIAPicker;
}());
var UIAPickerWheel = (function () {
    function UIAPickerWheel() {
    }
    UIAPickerWheel.prototype.selectValue = function () { };
    UIAPickerWheel.prototype.values = function () { };
    return UIAPickerWheel;
}());
var UIAPopover = (function () {
    function UIAPopover() {
    }
    UIAPopover.prototype.actionSheet = function () { };
    UIAPopover.prototype.navigationBar = function () { };
    UIAPopover.prototype.tabBar = function () { };
    UIAPopover.prototype.toolbar = function () { };
    UIAPopover.prototype.dismiss = function () { };
    return UIAPopover;
}());
var UIAProgressIndicator = (function () {
    function UIAProgressIndicator() {
    }
    return UIAProgressIndicator;
}());
var UIASearchBar = (function () {
    function UIASearchBar() {
    }
    return UIASearchBar;
}());
var UIASegmentedControl = (function () {
    function UIASegmentedControl() {
    }
    UIASegmentedControl.prototype.selectedButton = function () { };
    return UIASegmentedControl;
}());
var UIASlider = (function () {
    function UIASlider() {
    }
    UIASlider.prototype.dragToValue = function (value) { };
    return UIASlider;
}());
var UIAStaticText = (function () {
    function UIAStaticText() {
    }
    return UIAStaticText;
}());
var UIAStatusBar = (function () {
    function UIAStatusBar() {
    }
    return UIAStatusBar;
}());
var UIASwitch = (function () {
    function UIASwitch() {
    }
    UIASwitch.prototype.setValue = function (value) { };
    return UIASwitch;
}());
var UIATabBar = (function () {
    function UIATabBar() {
    }
    UIATabBar.prototype.selectedButton = function () { };
    return UIATabBar;
}());
var UIATextField = (function () {
    function UIATextField() {
    }
    return UIATextField;
}());
UIAElement;
{
    setValue(value, string);
    { }
}
var UIASecureTextField = (function () {
    function UIASecureTextField() {
    }
    return UIASecureTextField;
}());
UIATextField;
{
}
var UIATextView = (function () {
    function UIATextView() {
    }
    return UIATextView;
}());
UIAElement;
{
    setValue(value, string);
    { }
}
var UIAToolbar = (function () {
    function UIAToolbar() {
    }
    return UIAToolbar;
}());
var UIAWebView = (function () {
    function UIAWebView() {
    }
    return UIAWebView;
}());
//# sourceMappingURL=UIAutomation.js.map