/**
 * Created by wangchaojs02 on 16/4/27.
 */
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var UIA_DEVICE_ORIENTATION_UNKNOWN = 0;
var UIA_DEVICE_ORIENTATION_PORTRAIT = 0;
var UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN = 0;
var UIA_DEVICE_ORIENTATION_LANDSCAPELEFT = 0;
var UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT = 0;
var UIA_DEVICE_ORIENTATION_FACEUP = 0;
var UIA_DEVICE_ORIENTATION_FACEDOWN = 0;
var UIALogger = (function () {
    function UIALogger() {
    }
    UIALogger.logFail = function (message) {
    };
    UIALogger.logIssue = function (message) {
    };
    UIALogger.logPass = function (message) {
    };
    UIALogger.logStart = function (message) {
    };
    UIALogger.logDebug = function (message) {
    };
    UIALogger.logError = function (message) {
    };
    UIALogger.logMessage = function (message) {
    };
    UIALogger.logWarning = function (message) {
    };
    return UIALogger;
}());
var object = (function () {
    function object() {
    }
    return object;
}());
var Point = (function () {
    function Point() {
    }
    return Point;
}());
var Size = (function () {
    function Size() {
    }
    return Size;
}());
var Rect = (function () {
    function Rect() {
    }
    return Rect;
}());
var RectOrPointOrUIAElement = (function () {
    function RectOrPointOrUIAElement() {
    }
    return RectOrPointOrUIAElement;
}());
var RectOrPoint = (function () {
    function RectOrPoint() {
    }
    return RectOrPoint;
}());
var TapOptions = (function () {
    function TapOptions() {
    }
    return TapOptions;
}());
var DragOptions = (function () {
    function DragOptions() {
    }
    return DragOptions;
}());
var FlickOptions = (function () {
    function FlickOptions() {
    }
    return FlickOptions;
}());
var RotateOptions = (function () {
    function RotateOptions() {
    }
    return RotateOptions;
}());
var NotTyped = (function () {
    function NotTyped() {
    }
    return NotTyped;
}());
var PredicateString = (function () {
    function PredicateString() {
    }
    return PredicateString;
}());
var AnyArray = (function () {
    function AnyArray() {
    }
    return AnyArray;
}());
var Coordinate = (function () {
    function Coordinate(latitude, longitude) {
    }
    return Coordinate;
}());
var LocationOptions = (function () {
    function LocationOptions(altitude, horizontalAccuracy, verticalAccuracy, course, speed) {
    }
    return LocationOptions;
}());
var UIAHost = (function () {
    function UIAHost() {
    }
    UIAHost.prototype.performTaskWithPathArgumentsTimeout = function (path, args, timeout) {
        return null;
    };
    return UIAHost;
}());
var UIATarget = (function () {
    function UIATarget() {
    }
    UIATarget.prototype.host = function () {
        return null;
    };
    UIATarget.localTarget = function () {
        return null;
    };
    UIATarget.prototype.deactivateApp = function (duration) {
        return null;
    };
    UIATarget.prototype.frontMostApp = function () {
        return null;
    };
    UIATarget.prototype.model = function () {
        return null;
    };
    UIATarget.prototype.name = function () {
        return null;
    };
    UIATarget.prototype.rect = function () {
        return null;
    };
    UIATarget.prototype.systemName = function () {
        return null;
    };
    UIATarget.prototype.systemVersion = function () {
        return null;
    };
    UIATarget.prototype.deviceOrientation = function () {
        return null;
    };
    UIATarget.prototype.setDeviceOrientation = function (deviceOrientation) {
    };
    UIATarget.prototype.setLocation = function (coordinate) {
        return null;
    };
    UIATarget.prototype.setLocationWithOptions = function (coordinate, options) {
        return null;
    };
    UIATarget.prototype.holdVolumeDown = function (duration) {
    };
    UIATarget.prototype.holdVolumeUp = function (duration) {
    };
    UIATarget.prototype.lockForDuration = function (duration) {
    };
    UIATarget.prototype.lock = function () {
    };
    UIATarget.prototype.shake = function () {
    };
    UIATarget.prototype.unlock = function () {
    };
    UIATarget.prototype.dragFromToForDuration = function (from, to, duration) {
    };
    UIATarget.prototype.doubleTap = function (object) {
    };
    UIATarget.prototype.flickFromTo = function (from, to) {
    };
    UIATarget.prototype.pinchCloseFromToForDuration = function (from, to, duration) {
    };
    UIATarget.prototype.pinchOpenFromToForDuration = function (from, to, duration) {
    };
    UIATarget.prototype.rotateWithOptions = function (center, options) {
    };
    UIATarget.prototype.tap = function (object) {
    };
    UIATarget.prototype.tapWithOptions = function (object, options) {
    };
    UIATarget.prototype.touchAndHold = function (object, duration) {
    };
    UIATarget.prototype.captureRectWithName = function (rect, imageName) {
    };
    UIATarget.prototype.captureScreenWithName = function (imageName) {
    };
    UIATarget.prototype.popTimeout = function () {
        return null;
    };
    UIATarget.prototype.pushTimeout = function (timeoutValue) {
    };
    UIATarget.prototype.setTimeout = function (timeout) {
    };
    UIATarget.prototype.timeout = function () {
        return null;
    };
    UIATarget.prototype.delay = function (timeInterval) {
        return null;
    };
    UIATarget.prototype.onAlert = function (alert) {
        return null;
    };
    return UIATarget;
}());
var UIAApplication = (function () {
    function UIAApplication() {
    }
    UIAApplication.prototype.actionSheet = function () {
        return null;
    };
    UIAApplication.prototype.alert = function () {
        return null;
    };
    UIAApplication.prototype.bundleID = function () {
        return null;
    };
    UIAApplication.prototype.editingMenu = function () {
        return null;
    };
    UIAApplication.prototype.interfaceOrientation = function () {
        return null;
    };
    UIAApplication.prototype.keyboard = function () {
        return null;
    };
    UIAApplication.prototype.mainWindow = function () {
        return null;
    };
    UIAApplication.prototype.navigationBar = function () {
        return null;
    };
    UIAApplication.prototype.preferencesValueForKey = function (key) {
        return null;
    };
    UIAApplication.prototype.setPreferencesValueForKey = function (value, key) {
    };
    UIAApplication.prototype.statusBar = function () {
        return null;
    };
    UIAApplication.prototype.tabBar = function () {
        return null;
    };
    UIAApplication.prototype.toolbar = function () {
        return null;
    };
    UIAApplication.prototype.version = function () {
        return null;
    };
    UIAApplication.prototype.windows = function () {
        return null;
    };
    return UIAApplication;
}());
var UIAElement = (function () {
    function UIAElement() {
    }
    UIAElement.prototype.hitpoint = function () {
        return null;
    };
    UIAElement.prototype.rect = function () {
        return null;
    };
    UIAElement.prototype.activityIndicators = function () {
        return null;
    };
    UIAElement.prototype.activityView = function () {
        return null;
    };
    UIAElement.prototype.ancestry = function () {
        return null;
    };
    UIAElement.prototype.buttons = function () {
        return null;
    };
    UIAElement.prototype.collectionViews = function () {
        return null;
    };
    UIAElement.prototype.elements = function () {
        return null;
    };
    UIAElement.prototype.images = function () {
        return null;
    };
    UIAElement.prototype.links = function () {
        return null;
    };
    UIAElement.prototype.navigationBar = function () {
        return null;
    };
    UIAElement.prototype.navigationBars = function () {
        return null;
    };
    UIAElement.prototype.pageIndicators = function () {
        return null;
    };
    UIAElement.prototype.parent = function () {
        return null;
    };
    UIAElement.prototype.pickers = function () {
        return null;
    };
    UIAElement.prototype.popover = function () {
        return null;
    };
    UIAElement.prototype.progressIndicators = function () {
        return null;
    };
    UIAElement.prototype.scrollViews = function () {
        return null;
    };
    UIAElement.prototype.searchBars = function () {
        return null;
    };
    UIAElement.prototype.secureTextFields = function () {
        return null;
    };
    UIAElement.prototype.segmentedControls = function () {
        return null;
    };
    UIAElement.prototype.sliders = function () {
        return null;
    };
    UIAElement.prototype.staticTexts = function () {
        return null;
    };
    UIAElement.prototype.switches = function () {
        return null;
    };
    UIAElement.prototype.tabBar = function () {
        return null;
    };
    UIAElement.prototype.tabBars = function () {
        return null;
    };
    UIAElement.prototype.tableViews = function () {
        return null;
    };
    UIAElement.prototype.textFields = function () {
        return null;
    };
    UIAElement.prototype.textViews = function () {
        return null;
    };
    UIAElement.prototype.toolbar = function () {
        return null;
    };
    UIAElement.prototype.toolbars = function () {
        return null;
    };
    UIAElement.prototype.webViews = function () {
        return null;
    };
    UIAElement.prototype.doubleTap = function () {
    };
    UIAElement.prototype.dragInsideWithOptions = function (options) {
    };
    UIAElement.prototype.flickInsideWithOptions = function (options) {
    };
    UIAElement.prototype.rotateWithOptions = function (options) {
    };
    UIAElement.prototype.scrollToVisible = function () {
    };
    UIAElement.prototype.tap = function () {
    };
    UIAElement.prototype.tapWithOptions = function (options) {
    };
    UIAElement.prototype.touchAndHold = function (duration) {
    };
    UIAElement.prototype.twoFingerTap = function () {
    };
    UIAElement.prototype.checkIsValid = function () {
        return null;
    };
    UIAElement.prototype.hasKeyboardFocus = function () {
        return null;
    };
    UIAElement.prototype.isEnabled = function () {
        return null;
    };
    UIAElement.prototype.isValid = function () {
        return null;
    };
    UIAElement.prototype.isVisible = function () {
        return null;
    };
    UIAElement.prototype.waitForInvalid = function () {
        return null;
    };
    UIAElement.prototype.label = function () {
        return null;
    };
    UIAElement.prototype.name = function () {
        return null;
    };
    UIAElement.prototype.value = function () {
        return null;
    };
    UIAElement.prototype.withName = function (name) {
        return null;
    };
    UIAElement.prototype.withPredicate = function (predicateString) {
        return null;
    };
    UIAElement.prototype.withValueForKey = function (value, key) {
        return null;
    };
    UIAElement.prototype.logElement = function () {
    };
    UIAElement.prototype.logElementTree = function () {
    };
    return UIAElement;
}());
var UIAElementArray = (function () {
    function UIAElementArray() {
    }
    UIAElementArray.prototype.firstWithName = function (name) {
        return null;
    };
    UIAElementArray.prototype.firstWithPredicate = function (predicateString) {
        return null;
    };
    UIAElementArray.prototype.firstWithValueForKey = function (value, key) {
        return null;
    };
    UIAElementArray.prototype.toArray = function () {
        return null;
    };
    UIAElementArray.prototype.withName = function (name) {
        return null;
    };
    UIAElementArray.prototype.withPredicate = function (predicateString) {
        return null;
    };
    UIAElementArray.prototype.withValueForKey = function (value, key) {
        return null;
    };
    return UIAElementArray;
}());
var UIAWindow = (function (_super) {
    __extends(UIAWindow, _super);
    function UIAWindow() {
        _super.apply(this, arguments);
    }
    UIAWindow.prototype.contentArea = function () {
        return null;
    };
    UIAWindow.prototype.navigationBar = function () {
        return null;
    };
    UIAWindow.prototype.navigationBars = function () {
        return null;
    };
    UIAWindow.prototype.tabBar = function () {
        return null;
    };
    UIAWindow.prototype.tabBars = function () {
        return null;
    };
    UIAWindow.prototype.toolbar = function () {
        return null;
    };
    UIAWindow.prototype.toolbars = function () {
        return null;
    };
    return UIAWindow;
}(UIAElement));
var UIAScrollView = (function (_super) {
    __extends(UIAScrollView, _super);
    function UIAScrollView() {
        _super.apply(this, arguments);
    }
    UIAScrollView.prototype.scrollUp = function () {
    };
    UIAScrollView.prototype.scrollDown = function () {
    };
    UIAScrollView.prototype.scrollLeft = function () {
    };
    UIAScrollView.prototype.scrollRight = function () {
    };
    UIAScrollView.prototype.scrollToElementWithName = function (name) {
        return null;
    };
    UIAScrollView.prototype.scrollToElementWithPredicate = function (predicateString) {
        return null;
    };
    UIAScrollView.prototype.scrollToElementWithValueForKey = function (value, key) {
        return null;
    };
    return UIAScrollView;
}(UIAElement));
var UIATableView = (function (_super) {
    __extends(UIATableView, _super);
    function UIATableView() {
        _super.apply(this, arguments);
    }
    UIATableView.prototype.cells = function () {
        return null;
    };
    UIATableView.prototype.groups = function () {
        return null;
    };
    UIATableView.prototype.visibleCells = function () {
        return null;
    };
    return UIATableView;
}(UIAScrollView));
var UIATableCell = (function (_super) {
    __extends(UIATableCell, _super);
    function UIATableCell() {
        _super.apply(this, arguments);
    }
    return UIATableCell;
}(UIAElement));
var UIATableGroup = (function (_super) {
    __extends(UIATableGroup, _super);
    function UIATableGroup() {
        _super.apply(this, arguments);
    }
    return UIATableGroup;
}(UIAElement));
var UIACollectionView = (function (_super) {
    __extends(UIACollectionView, _super);
    function UIACollectionView() {
        _super.apply(this, arguments);
    }
    UIACollectionView.prototype.cells = function () {
        return null;
    };
    UIACollectionView.prototype.visibleCells = function () {
        return null;
    };
    return UIACollectionView;
}(UIAScrollView));
var UIAButton = (function (_super) {
    __extends(UIAButton, _super);
    function UIAButton() {
        _super.apply(this, arguments);
    }
    return UIAButton;
}(UIAElement));
var UIAActionSheet = (function (_super) {
    __extends(UIAActionSheet, _super);
    function UIAActionSheet() {
        _super.apply(this, arguments);
    }
    UIAActionSheet.prototype.cancelButton = function () {
        return null;
    };
    return UIAActionSheet;
}(UIAElement));
var UIAActivityIndicator = (function () {
    function UIAActivityIndicator() {
    }
    return UIAActivityIndicator;
}());
var UIAActivityView = (function (_super) {
    __extends(UIAActivityView, _super);
    function UIAActivityView() {
        _super.apply(this, arguments);
    }
    UIAActivityView.prototype.cancelButton = function () {
        return null;
    };
    return UIAActivityView;
}(UIAElement));
var UIAAlert = (function (_super) {
    __extends(UIAAlert, _super);
    function UIAAlert() {
        _super.apply(this, arguments);
    }
    UIAAlert.prototype.cancelButton = function () {
        return null;
    };
    UIAAlert.prototype.defaultButton = function () {
        return null;
    };
    return UIAAlert;
}(UIAElement));
var UIAEditingMenu = (function (_super) {
    __extends(UIAEditingMenu, _super);
    function UIAEditingMenu() {
        _super.apply(this, arguments);
    }
    return UIAEditingMenu;
}(UIAElement));
var UIAKey = (function (_super) {
    __extends(UIAKey, _super);
    function UIAKey() {
        _super.apply(this, arguments);
    }
    return UIAKey;
}(UIAElement));
var UIAKeyboard = (function (_super) {
    __extends(UIAKeyboard, _super);
    function UIAKeyboard() {
        _super.apply(this, arguments);
    }
    UIAKeyboard.prototype.keys = function () {
        return null;
    };
    UIAKeyboard.prototype.typeString = function (string) {
    };
    return UIAKeyboard;
}(UIAElement));
var UIALink = (function (_super) {
    __extends(UIALink, _super);
    function UIALink() {
        _super.apply(this, arguments);
    }
    UIALink.prototype.url = function () {
        return null;
    };
    return UIALink;
}(UIAElement));
var UIANavigationBar = (function (_super) {
    __extends(UIANavigationBar, _super);
    function UIANavigationBar() {
        _super.apply(this, arguments);
    }
    UIANavigationBar.prototype.leftButton = function () {
        return null;
    };
    UIANavigationBar.prototype.rightButton = function () {
        return null;
    };
    return UIANavigationBar;
}(UIAElement));
var UIAPageIndicator = (function (_super) {
    __extends(UIAPageIndicator, _super);
    function UIAPageIndicator() {
        _super.apply(this, arguments);
    }
    UIAPageIndicator.prototype.goToNextPage = function () {
    };
    UIAPageIndicator.prototype.goToPreviousPage = function () {
    };
    UIAPageIndicator.prototype.pageCount = function () {
        return null;
    };
    UIAPageIndicator.prototype.pageIndex = function () {
        return null;
    };
    UIAPageIndicator.prototype.selectPage = function (index) {
    };
    return UIAPageIndicator;
}(UIAElement));
var UIAPicker = (function (_super) {
    __extends(UIAPicker, _super);
    function UIAPicker() {
        _super.apply(this, arguments);
    }
    UIAPicker.prototype.wheels = function () {
        return null;
    };
    return UIAPicker;
}(UIAElement));
var UIAPickerWheel = (function (_super) {
    __extends(UIAPickerWheel, _super);
    function UIAPickerWheel() {
        _super.apply(this, arguments);
    }
    UIAPickerWheel.prototype.selectValue = function () {
    };
    UIAPickerWheel.prototype.values = function () {
        return null;
    };
    return UIAPickerWheel;
}(UIAPicker));
var UIAPopover = (function (_super) {
    __extends(UIAPopover, _super);
    function UIAPopover() {
        _super.apply(this, arguments);
    }
    UIAPopover.prototype.actionSheet = function () {
        return null;
    };
    UIAPopover.prototype.navigationBar = function () {
        return null;
    };
    UIAPopover.prototype.tabBar = function () {
        return null;
    };
    UIAPopover.prototype.toolbar = function () {
        return null;
    };
    UIAPopover.prototype.dismiss = function () {
        return null;
    };
    return UIAPopover;
}(UIAElement));
var UIAProgressIndicator = (function (_super) {
    __extends(UIAProgressIndicator, _super);
    function UIAProgressIndicator() {
        _super.apply(this, arguments);
    }
    return UIAProgressIndicator;
}(UIAElement));
var UIASearchBar = (function (_super) {
    __extends(UIASearchBar, _super);
    function UIASearchBar() {
        _super.apply(this, arguments);
    }
    return UIASearchBar;
}(UIATextField));
var UIASegmentedControl = (function (_super) {
    __extends(UIASegmentedControl, _super);
    function UIASegmentedControl() {
        _super.apply(this, arguments);
    }
    UIASegmentedControl.prototype.selectedButton = function () {
        return null;
    };
    return UIASegmentedControl;
}(UIAElement));
var UIASlider = (function (_super) {
    __extends(UIASlider, _super);
    function UIASlider() {
        _super.apply(this, arguments);
    }
    UIASlider.prototype.dragToValue = function (value) {
    };
    return UIASlider;
}(UIAElement));
var UIAStaticText = (function (_super) {
    __extends(UIAStaticText, _super);
    function UIAStaticText() {
        _super.apply(this, arguments);
    }
    return UIAStaticText;
}(UIAElement));
var UIAStatusBar = (function (_super) {
    __extends(UIAStatusBar, _super);
    function UIAStatusBar() {
        _super.apply(this, arguments);
    }
    return UIAStatusBar;
}(UIAElement));
var UIASwitch = (function (_super) {
    __extends(UIASwitch, _super);
    function UIASwitch() {
        _super.apply(this, arguments);
    }
    UIASwitch.prototype.setValue = function (value) {
    };
    return UIASwitch;
}(UIAElement));
var UIATabBar = (function (_super) {
    __extends(UIATabBar, _super);
    function UIATabBar() {
        _super.apply(this, arguments);
    }
    UIATabBar.prototype.selectedButton = function () {
        return null;
    };
    return UIATabBar;
}(UIAElement));
var UIATextField = (function (_super) {
    __extends(UIATextField, _super);
    function UIATextField() {
        _super.apply(this, arguments);
    }
    UIATextField.prototype.setValue = function (value) {
    };
    return UIATextField;
}(UIAElement));
var UIASecureTextField = (function (_super) {
    __extends(UIASecureTextField, _super);
    function UIASecureTextField() {
        _super.apply(this, arguments);
    }
    return UIASecureTextField;
}(UIATextField));
var UIATextView = (function (_super) {
    __extends(UIATextView, _super);
    function UIATextView() {
        _super.apply(this, arguments);
    }
    UIATextView.prototype.setValue = function (value) {
    };
    return UIATextView;
}(UIAElement));
var UIAToolbar = (function (_super) {
    __extends(UIAToolbar, _super);
    function UIAToolbar() {
        _super.apply(this, arguments);
    }
    return UIAToolbar;
}(UIAElement));
var UIAWebView = (function (_super) {
    __extends(UIAWebView, _super);
    function UIAWebView() {
        _super.apply(this, arguments);
    }
    return UIAWebView;
}(UIAScrollView));
//# sourceMappingURL=UIAutomation.js.map