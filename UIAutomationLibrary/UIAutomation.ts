/**
 * Created by wangchaojs02 on 16/4/27.
 */

enum UIA_DEVICE_ORIENTATION{
    UIA_DEVICE_ORIENTATION_UNKNOWN = 1,
    UIA_DEVICE_ORIENTATION_PORTRAIT,
    UIA_DEVICE_ORIENTATION_PORTRAIT_UPSIDEDOWN,
    UIA_DEVICE_ORIENTATION_LANDSCAPELEFT,
    UIA_DEVICE_ORIENTATION_LANDSCAPERIGHT,
    UIA_DEVICE_ORIENTATION_FACEUP,
    UIA_DEVICE_ORIENTATION_FACEDOWN,
    }
class UIALogger {
    logFail(message:string){}
    logIssue(message:string){}
    logPass(message:string){}
    logStart(message:string){}
    logDebug(message:string){}
    logError(message:string){}
    logMessage(message:string){}
    logWarning(message:string){}
}
class UIAHost {
    performTaskWithPathArgumentsTimeout(path, args, timeout):object{}
}
class Coordinate{
    constructor(latitude:Number,longitude:Number){}
}
class LocationOptions{
    constructor(altitude:Number,horizontalAccuracy:Number,
                verticalAccuracy:Number,course:Number,speed:Number)
}
class UIATarget {
    host():UIAHost{}
    localTarget():UIATarget{}
    deactivateApp(duration:Number):Boolean{}
    frontMostApp():UIAApplication{}
    model():string{}
    name():string{}
    rect():Rect{}
    systemName():string{}
    systemVersion():string{}
    deviceOrientation():UIA_DEVICE_ORIENTATION{}
    setDeviceOrientation(deviceOrientation:UIA_DEVICE_ORIENTATION){}
    setLocation(coordinate:Coordinate):boolean{}
    setLocationWithOptions(coordinate:Coordinate,options:LocationOptions):boolean{}
    holdVolumeDown(duration:Number){}
    holdVolumeUp(duration:Number){}
    lockForDuration(duration:Number){}
    lock(){}
    shake(){}
    unlock(){}
    dragFromToForDuration(rect|point, rect|point, duration:Number){}
doubleTap(rect|point|UIAElement){}
flickFromTo(rect|point, rect|point){}
pinchCloseFromToForDuration(rect|point, rect|point, duration:Number){}
pinchOpenFromToForDuration(rect|point, rect|point, duration:Number){}
rotateWithOptions({x:,y:}, {duration:,radius:,rotation:,touchCount:}){}
tap(rect|point|UIAElement){}
tapWithOptions(rect|point|UIAElement, {tapCount:,touchCount:,duration:}){}
touchAndHold(rect|point|UIAElement, duration:Number){}
captureRectWithName(rect:Rect, imageName:string){}
captureScreenWithName(imageName:string){}
popTimeout():Number{}
pushTimeout(timeoutValue){}
setTimeout(timeout:Number){}
timeout():Number{}
delay(timeInterval:Number):Boolean{}
onAlert(alert:UIAAlert):Boolean{}
}
class UIAApplication {
    actionSheet():UIAActionSheet{}
    alert():UIAAlert{}
    bundleID():string{}
    editingMenu():UIAEditingMenu{}
    interfaceOrientation():Number{}
    keyboard():UIAKeyboard{}
    mainWindow():UIAWindow{}
    navigationBar()):UIANavigationBar{}
preferencesValueForKey(key):NotTyped{}
setPreferencesValueForKey(value:NotTyped, key:string){}
statusBar():UIAStatusBar{}
tabBar():UIATabBar{}
toolbar():UIAToolbar{}
version():string{}
windows():UIAElementArray{}
}
class UIAElement {
    hitpoint():Point{}
    rect():Rect{}
    activityIndicators():UIAElementArray{}
    activityView():UIAActivityView{}
    ancestry():UIAElementArray{}
    buttons():UIAElementArray{}
(UIAElementArray collectionViews()
    elements():UIAElementArray{}
    images():UIAElementArray{}
    links():UIAElementArray{}
    navigationBar():UIAElement{}
    navigationBars():UIAElementArray{}
    pageIndicators():UIAElementArray{}
    parent():UIAElement{}
    pickers():UIAElementArray{}
    popover():UIAPopover{}
    progressIndicators():UIAElementArray{}
    scrollViews():UIAElementArray{}
    searchBars():UIAElementArray{}
    secureTextFields():UIAElementArray{}
    segmentedControls():UIAElementArray{}
    sliders():UIAElementArray{}
    staticTexts():UIAElementArray{}
    switches():UIAElementArray{}
    tabBar():UIAElement{}
    tabBars():UIAElementArray{}
    tableViews():UIAElementArray{}
    textFields():UIAElementArray{}
    textViews():UIAElementArray{}
    toolbar():UIAElement{}
    toolbars():UIAElementArray{}
    webViews():UIAElementArray{}
    doubleTap(){}
    dragInsideWithOptions({touchCount:,duration:,startOffset:{x:, y:},endOffset:{x:, y:}}){}
    flickInsideWithOptions({touchCount:,startOffset:{x:, y:},endOffset:{x:, y:}}){}
    rotateWithOptions({centerOffset:,duration:,radius:,rotation:,touchCount:}){}
    scrollToVisible(){}
    tap(){}
    tapWithOptions({tapCount:,touchCount:,duration:,tapOffset:}){}
    touchAndHold(duration:Number){}
    twoFingerTap(){}
    checkIsValid():Boolean{}
    hasKeyboardFocus():Number{}
    isEnabled():Number{}
    isValid():Boolean{}
    isVisible():Number{}
    waitForInvalid():Boolean{}
    label():string{}
    name():string{}
    value():string{}
    withName(name:string):UIAElement{}
    withPredicate(predicateString:PredicateString):UIAElement{}
    withValueForKey(value:NotTyped, key:string):UIAElement{}
    logElement(){}
    logElementTree(){}
}
class UIAElementArray {
(Number) length
    firstWithName(name:string):UIAElement{}
    firstWithPredicate(predicateString:PredicateString):UIAElement{}
    firstWithValueForKey(value:NotTyped, key:string):UIAElement{}
    toArray():Array{}
    withName(name:string):UIAElementArray{}
    withPredicate(predicateString:PredicateString):UIAElementArray{}
    withValueForKey(value:NotTyped, key:string):UIAElementArray{}
UIAElementNil
}
class UIAScrollView {
    scrollUp(){}
    scrollDown(){}
    scrollLeft(){}
    scrollRight(){}
    scrollToElementWithName(name:string):UIAElement{}
    scrollToElementWithPredicate(predicateString:PredicateString):UIAElement{}
    scrollToElementWithValueForKey(value:NotTyped, key:string):UIAElement{}
}
class UIATableView : UIAScrollView {
    cells():UIAElementArray{}
    groups():UIAElementArray{}
    visibleCells():UIAElementArray{}
}
class UIATableCell {
}
class UIATableGroup {
}
class UIACollectionView {
    cells():UIAElementArray{}
    visibleCells():UIAElementArray{}
}
class UIAButton {
}
class UIAActionSheet {
    cancelButton():UIAButton{}
}
class UIAActivityIndicator {
}
class UIAActivityView {
    cancelButton():UIAButton{}
}
class UIAAlert {
    cancelButton():UIAButton{}
    defaultButton():UIAButton{}
}
class UIAEditingMenu {

}
class UIAKey {
}
class UIAKeyboard {
    keys():UIAElementArray{}
    typeString(string:string){}
}
class UIALink {
    url():string{}
}
class UIANavigationBar {
    leftButton():UIAButton{}
    rightButton():UIAButton{}
}
class UIAPageIndicator {
    goToNextPage(){}
    goToPreviousPage(){}
    pageCount():Number{}
    pageIndex():Number{}
    selectPage(index:Number){}
}
class UIAPicker {
    wheels():UIAElementArray{}
}
class UIAPickerWheel {
    selectValue(){}
    values():Array{}
}
class UIAPopover {
    actionSheet():UIAActionSheet{}
    navigationBar():UIANavigationBar{}
    tabBar():UIATabBar{}
    toolbar():UIAToolbar{}
    dismiss():void{}
}
class UIAProgressIndicator {
}
class UIASearchBar {
}
class UIASegmentedControl {
    selectedButton():UIAElement{}
}
class UIASlider {
    dragToValue(value:Number){}
}
class UIAStaticText {
}
class UIAStatusBar {
}
class UIASwitch {
    setValue(value:Boolean){}
}
class UIATabBar {
    selectedButton():UIAButton{}
}
class UIATextField: UIAElement {
    setValue(value:string){}
}
class UIASecureTextField: UIATextField {
}
class UIATextView: UIAElement {
    setValue(value:string){}
}
class UIAToolbar {
}
class UIAWebView {
