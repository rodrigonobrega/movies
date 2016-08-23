UIALogger.logDebug("Starting... Change Search");

var target      = UIATarget.localTarget();
var window      = target.frontMostApp().mainWindow();
var topRated    = window.collectionViews()[0].segmentedControls()[0].buttons()["Top Rated"];
var popularity  = window.collectionViews()[0].segmentedControls()[0].buttons()["Popularity"];

var testTimes = 4;

while (testTimes > 0) {
    target.delay(1);
    changeType();
    testTimes--;
}

function changeType() {
    topRated.tap();
    target.delay(1);
    popularity.tap();
    target.delay(1);
}
