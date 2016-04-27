/**
 * Created by wangchaojs02 on 16/4/27.
 */

var Class = function() {
    var parent,
        methods,
        class_template = function() {
        this.initialize.apply(this, arguments);
        //copy the properties so that they can be called directly from the child
        //class without $super, i.e., this.name
        var reg = /\(([\s\S]*?)\)/;
        var params = reg.exec(this.initialize.toString());
        if (params) {
            var param_names = params[1].split(',');
            for ( var i=0; i<param_names.length; i++ ) {
                this[param_names[i]] = arguments[i];
            }
        }
    },
        extend = function(destination, source) {
            for (var property in source) {
                destination[property] = source[property];
            }

            destination.$super =  function(method) {
                return this.$parent[method].apply(this.$parent, Array.prototype.slice.call(arguments, 1));
            }
            return destination;
        };

    if (typeof arguments[0] === 'function') {
        parent  = arguments[0];
        methods = arguments[1];
    } else {
        methods = arguments[0];
    }

    if (parent !== undefined) {
        extend(class_template.prototype, parent.prototype);
        class_template.prototype.$parent = parent.prototype;
    }
    extend(class_template.prototype, methods);
    class_template.prototype.constructor = class_template;

    if (!class_template.prototype.initialize) class_template.prototype.initialize = function(){};

    return class_template;
};

var UIALogger = Class({
    initialize: function() {},
    /**
     *
     * return undefined
     */
    logFail : function(message) {},
    /**
     *
     * return undefined
     */
    logIssue : function(message) {},
    /**
     *
     * return undefined
     */
    logPass : function(message) {},
    /**
     *
     * return undefined
     */
    logStart : function(message) {},
    /**
     *
     * return undefined
     */
    logDebug : function(message) {},
    /**
     *
     * return undefined
     */
    logError : function(message) {},
    /**
     *
     * return undefined
     */
    logMessage : function(message) {},
    /**
     *
     * return undefined
     */
    logWarning : function(message) {}
});

var UIAHost = Class({
    initialize: function() {},
    /**
     *
     * return object
     */
    performTaskWithPathArgumentsTimeout : function(path, args, timeout) {}
});

var UIATarget = Class({
    initialize: function() {},
    /**
     *
     * return UIAHost
     */
    host : function() {},
    /**
     *
     * return UIATarget
     */
    localTarget : function() {},
    /**
     * duration Number
     * return Boolean
     */
    deactivateApp : function(duration) {},
    /**
     *
     * return UIAApplication
     */
    frontMostApp : function() {},
    /**
     *
     * return String
     */
    model : function() {},
    /**
     *
     * return String
     */
    name : function() {},
    /**
     *
     * return Rect
     */
    rect : function() {},
    /**
     *
     * return String
     */
    systemName : function() {},
    /**
     *
     * return String
     */
    systemVersion : function() {},
    /**
     *
     * return Number deviceOrientation
     */
    deviceOrientation : function() {},
    /**
     *
     * return undefined
     */
    setDeviceOrientation : function(deviceOrientation) {},
    /**
     * coordinate : {latitude:,longitude:}
     * return boolean
     */
    setLocation : function(coordinate) {},
    /**
     * coordinate : {latitude:,longitude:}
     * options : {altitude:,course:,speed:,
     *            horizontalAccuracy:,
     *            verticalAccuracy:}
     * return boolean
     */
    setLocationWithOptions : function(coordinate, options){},
    /**
     * duration Number
     * return undefined
     */
    holdVolumeDown : function(duration) {},
    /**
     * duration Number
     * return undefined
     */
    holdVolumeUp : function(duration) {},
    /**
     * duration Number
     * return undefined
     */
    lockForDuration : function(duration) {},
    /**
     *
     * return undefined
     */
    lock : function() {},
    /**
     *
     * return undefined
     */
    shake : function() {},
    /**
     *
     * return undefined
     */
    unlock : function() {},
    /**
     * from rect|point
     * to   rect|point
     * duration Number
     * return undefined
     */
    dragFromToForDuration : function(from, to, duration) {},
    /**
     * object rect|point|UIAElement
     * return undefined
     */
    doubleTap : function(object) {},
    /**
     * from rect|point
     * to   rect|point
     * return undefined
     */
    flickFromTo : function(from, to) {},
    /**
     * from rect|point
     * to   rect|point
     * duration Number
     * return undefined
     */
    pinchCloseFromToForDuration : function(from, to, duration) {},
    /**
     * from rect|point
     * to   rect|point
     * duration Number
     * return undefined
     */
    pinchOpenFromToForDuration : function(from, to, duration) {},
    /**
     * center {x:,y:}
     * options {duration:,radius:,rotation:,touchCount:}
     * return undefined
     */
    rotateWithOptions : function(center, options) {},
    /**
     * object rect | point | UIAElement
     * return undefined
     */
    tap : function(object) {},
/**
 * object rect|point|UIAElement
 * options {tapCount:,touchCount:,duration:}
 * return undefined
 */
tapWithOptions : function(object, options) {},
/**
 * object rect|point|UIAElement
 * duration Number
 * return undefined
 */
touchAndHold : function(object, duration) {},
/**
 *
 * return undefined
 */
captureRectWithName : function(rect, imageName) {},
/**
 *
 * return undefined
 */
captureScreenWithName : function(imageName) {},
/**
 *
 * return Number
 */
popTimeout : function() {},
/**
 *
 * return undefined
 */
pushTimeout : function(timeoutValue) {},
/**
 *
 * return undefined
 */
setTimeout : function(timeout) {},
/**
 *
 * return Number
 */
timeout : function() {},
/**
 *
 * return Boolean
 */
delay : function(timeInterval) {},
/**
 *
 * return Boolean
 */
onAlert : function(alert) {}
});

var UIAApplication = Class({
    initialize: function() {},
    /**
     *
     * return UIAActionSheet
     */
    actionSheet : function() {},
    /**
     *
     * return UIAAlert
     */
    alert : function() {},
    /**
     *
     * return String
     */
    bundleID : function() {},
    /**
     *
     * return UIAEditingMenu
     */
    editingMenu : function() {},
    /**
     *
     * return Number
     */
    interfaceOrientation : function() {},
    /**
     *
     * return UIAKeyboard
     */
    keyboard : function() {},
    /**
     *
     * return UIAWindow
     */
    mainWindow : function() {},
    /**
     *
     * return UIANavigationBar
     */
    navigationBar : function() {},
    /**
     *
     * return NotTyped
     */
    preferencesValueForKey : function(key) {},
    /**
     *
     * return undefined
     */
    setPreferencesValueForKey : function(value, key) {},
    /**
     *
     * return UIAStatusBar
     */
    statusBar : function() {},
    /**
     *
     * return UIATabBar
     */
    tabBar : function() {},
    /**
     *
     * return UIAToolbar
     */
    toolbar : function() {},
    /**
     *
     * return String
     */
    version : function() {},
    /**
     *
     * return UIAElementArray
     */
    windows : function() {}
});

var UIAElement = Class({
    initialize: function() {},
    /**
     *
     * return Point
     */
    hitpoint : function() {},
    /**
     *
     * return Rect
     */
    rect : function() {},
    /**
     *
     * return UIAElementArray
     */
    activityIndicators : function() {},
    /**
     *
     * return UIAActivityView
     */
    activityView : function() {},
    /**
     *
     * return UIAElementArray
     */
    ancestry : function() {},
    /**
     *
     * return UIAElementArray
     */
    buttons : function() {},
    /**
     *
     * return UIAElementArray
     */
    collectionViews:function () {},
/**
 *
 * return UIAElementArray
 */
elements : function() {},
/**
 *
 * return UIAElementArray
 */
images : function() {},
/**
 *
 * return UIAElementArray
 */
links : function() {},
/**
 *
 * return UIAElement
 */
navigationBar : function() {},
/**
 *
 * return UIAElementArray
 */
navigationBars : function() {},
/**
 *
 * return UIAElementArray
 */
pageIndicators : function() {},
/**
 *
 * return UIAElement
 */
parent : function() {},
/**
 *
 * return UIAElementArray
 */
pickers : function() {},
/**
 *
 * return UIAPopover
 */
popover : function() {},
/**
 *
 * return UIAElementArray
 */
progressIndicators : function() {},
/**
 *
 * return UIAElementArray
 */
scrollViews : function() {},
/**
 *
 * return UIAElementArray
 */
searchBars : function() {},
/**
 *
 * return UIAElementArray
 */
secureTextFields : function() {},
/**
 *
 * return UIAElementArray
 */
segmentedControls : function() {},
/**
 *
 * return UIAElementArray
 */
sliders : function() {},
/**
 *
 * return UIAElementArray
 */
staticTexts : function() {},
/**
 *
 * return UIAElementArray
 */
switches : function() {},
/**
 *
 * return UIAElement
 */
tabBar : function() {},
/**
 *
 * return UIAElementArray
 */
tabBars : function() {},
/**
 *
 * return UIAElementArray
 */
tableViews : function() {},
/**
 *
 * return UIAElementArray
 */
textFields : function() {},
/**
 *
 * return UIAElementArray
 */
textViews : function() {},
/**
 *
 * return UIAElement
 */
toolbar : function() {},
/**
 *
 * return UIAElementArray
 */
toolbars : function() {},
/**
 *
 * return UIAElementArray
 */
webViews : function() {},
/**
 *
 * return undefined
 */
doubleTap : function() {},
/**
 * options {touchCount:,duration:,startOffset:{x:, y:},endOffset:{x:, y:}}
 * return undefined
 */
dragInsideWithOptions : function(options) {},
/**
 * options {touchCount:,startOffset:{x:, y:},endOffset:{x:, y:}}
 * return undefined
 */
flickInsideWithOptions : function() {},
/**
 * options {centerOffset:,duration:,radius:,rotation:,touchCount:}
 * return undefined
 */
rotateWithOptions : function(options) {},
/**
 *
 * return undefined
 */
scrollToVisible : function() {},
/**
 *
 * return undefined
 */
tap : function() {},
/**
 * options {tapCount:,touchCount:,duration:,tapOffset:}
 * return undefined
 */
tapWithOptions : function(options) {},
/**
 * duration Number
 * return undefined
 */
touchAndHold : function(duration) {},
/**
 *
 * return undefined
 */
twoFingerTap : function() {},
/**
 *
 * return Boolean
 */
checkIsValid : function() {},
/**
 *
 * return Number
 */
hasKeyboardFocus : function() {},
/**
 *
 * return Number
 */
isEnabled : function() {},
/**
 *
 * return Boolean
 */
isValid : function() {},
/**
 *
 * return Number
 */
isVisible : function() {},
/**
 *
 * return Boolean
 */
waitForInvalid : function() {},
/**
 *
 * return String
 */
label : function() {},
/**
 *
 * return String
 */
name : function() {},
/**
 *
 * return String
 */
value : function() {},
/**
 *
 * return UIAElement
 */
withName : function(name) {},
/**
 *
 * return UIAElement
 */
withPredicate : function(predicateString) {},
/**
 *
 * return UIAElement
 */
withValueForKey : function(value, key) {},
/**
 *
 * return undefined
 */
logElement : function() {},
/**
 *
 * return undefined
 */
logElementTree : function() {}
});

var UIAElementArray = Class({
    initialize: function() {},
    /**
     *
     * return Number
     */
    length:0,
/**
 *
 * return UIAElement
 */
firstWithName : function(name) {},
/**
 *
 * return UIAElement
 */
firstWithPredicate : function(predicateString) {},
/**
 *
 * return UIAElement
 */
firstWithValueForKey : function(value, key) {},
/**
 *
 * return Array
 */
toArray : function() {},
/**
 *
 * return UIAElementArray
 */
withName : function(name) {},
/**
 *
 * return UIAElementArray
 */
withPredicate : function(predicateString) {},
/**
 *
 * return UIAElementArray
 */
withValueForKey : function(value, key) {}
});
var UIAScrollView = Class({
    initialize: function() {},
    /**
     *
     * return undefined
     */
    scrollUp : function() {},
    /**
     *
     * return undefined
     */
    scrollDown : function() {},
    /**
     *
     * return undefined
     */
    scrollLeft : function() {},
    /**
     *
     * return undefined
     */
    scrollRight : function() {},
    /**
     *
     * return UIAElement
     */
    scrollToElementWithName : function(name) {},
    /**
     *
     * return UIAElement
     */
    scrollToElementWithPredicate : function(predicateString) {},
    /**
     *
     * return UIAElement
     */
    scrollToElementWithValueForKey : function(value, key) {}
});

var UIATableView = Class(UIAScrollView,{
    initialize: function() {},
/**
 *
 * return UIAElementArray
 */
cells : function() {},
/**
 *
 * return UIAElementArray
 */
groups : function() {},
/**
 *
 * return UIAElementArray
 */
visibleCells : function() {}
});

var UIATableCell = Class({
    initialize: function() {}
});

var UIATableGroup = Class({
    initialize: function() {}
});

var UIACollectionView = Class({
    initialize: function() {},
    /**
     *
     * return UIAElementArray
     */
    cells : function() {},
    /**
     *
     * return UIAElementArray
     */
    visibleCells : function() {}
});

var UIAButton = Class({
    initialize: function() {}
});

var UIAActionSheet = Class({
    initialize: function() {},

    /**
     *
     * return UIAButton
     */
    cancelButton : function() {}
});
var UIAActivityIndicator = Class({
    initialize: function() {}
});

var UIAActivityView = Class({
    initialize: function() {},

    /**
     *
     * return UIAButton
     */
    cancelButton : function() {}
});
var UIAAlert = Class({
    initialize: function() {},
    /**
     *
     * return UIAButton
     */
    cancelButton : function() {},
    /**
     *
     * return UIAButton
     */
    defaultButton : function() {}
});
var UIAEditingMenu = Class({
    initialize: function() {}
});


var UIAKey = Class({
    initialize: function() {}
});

var UIAKeyboard = Class({
    initialize: function() {},
    /**
     *
     * return UIAElementArray
     */
    keys : function() {},
    /**
     *
     * return undefined
     */
    typeString : function(string) {}
});

var UIALink = Class({
    initialize: function() {},
    /**
     *
     * return String
     */
    url : function() {}
});

var UIANavigationBar = Class({
    initialize: function() {},
    /**
     *
     * return UIAButton
     */
    leftButton : function() {},
    /**
     *
     * return UIAButton
     */
    rightButton : function() {}
});

var UIAPageIndicator = Class({
    initialize: function() {},
    /**
     *
     * return undefined
     */
    goToNextPage : function() {},
    /**
     *
     * return undefined
     */
    goToPreviousPage : function() {},
    /**
     *
     * return Number
     */
    pageCount : function() {},
    /**
     *
     * return Number
     */
    pageIndex : function() {},
    /**
     *
     * return undefined
     */
    selectPage : function(index) {}
});

var UIAPicker = Class({
    initialize: function() {},
    /**
     *
     * return UIAElementArray
     */
    wheels : function() {}
});

var UIAPickerWheel = Class({
    initialize: function() {},
    /**
     *
     * return undefined
     */
    selectValue : function() {},
    /**
     *
     * return Array
     */
    values : function() {}
});

var UIAPopover = Class({
    initialize: function() {},
    /**
     *
     * return UIAActionSheet
     */
    actionSheet : function() {},
    /**
     *
     * return UIANavigationBar
     */
    navigationBar : function() {},
    /**
     *
     * return UIATabBar
     */
    tabBar : function() {},
    /**
     *
     * return UIAToolbar
     */
    toolbar : function() {},
    /**
     *
     * return void
     */
    dismiss : function() {}
});

var UIAProgressIndicator = Class({
    initialize: function() {}
});

var UIASearchBar = Class({
    initialize: function() {}
});

var UIASegmentedControl = Class({
    initialize: function() {},
    /**
     *
     * return UIAElement
     */
    selectedButton : function() {}
});

var UIASlider = Class({
    initialize: function() {},
    /**
     *
     * return undefined
     */
    dragToValue : function(value) {}
});

var UIAStaticText = Class({
    initialize: function() {}
});

var UIAStatusBar = Class({
    initialize: function() {}
});

var UIASwitch = Class({
    initialize: function() {},
    /**
     *
     * return undefined
     */
    setValue : function(value) {}
});

var UIATabBar = Class({
    initialize: function() {},
    /**
     *
     * return UIAButton
     */
    selectedButton : function() {}
});

var UIATextField = Class(UIAElement, {
    initialize: function() {},
    /**
     *
     * return undefined
     */
    setValue : function(value) {}
});

var UIASecureTextField = Class(UIATextField, {
    initialize: function() {}

});

var UIATextView = Class(UIAElement, {
    initialize: function() {},
    /**
     *
     * return undefined
     */
    setValue : function(value) {}
});

var UIAToolbar = Class({
    initialize: function() {}
});

var UIAWebView = Class({
    initialize: function() {}
});

