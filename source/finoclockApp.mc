
import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Background;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class finoclockApp extends Application.AppBase {
    var analytics = new Analytics();

    function initialize() {
        AppBase.initialize();
    }


    function onStart(state as Dictionary?) as Void {
        //System.println("App onStart");
        var settings = System.getDeviceSettings();
        Storage.setValue("deviceId", settings.uniqueIdentifier);
        Storage.setValue("partNumber", settings.partNumber);
        // fire every six hours, to check if this day was used, also send settings changes, if stored
        Background.registerForTemporalEvent(new Time.Duration(6*6*60));

    }

    function onAppInstall() as Void {
        analytics.track("install", null);
        Background.exit(null);
    }

    function onAppUpdate() as Void {
        analytics.track("update", null);
        Background.exit(null);
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new finoclockView() ];
    }

    function onSettingsChanged() as Void {
        Settings.getProperties();
        analytics.trackSettings(Settings.getPropertiesAsDict());
        WatchUi.requestUpdate();
    }

    function getSettingsView() {
        // free active bitmap from the watch face view before the Menu allocates,
        // otherwise opening Menu OOMs on memory-constrained devices like descentmk2s.
        if (ViewRef.view != null) { ViewRef.view.releaseHeavyResources(); }
        return [new Menu(), new MenuDelegate()];
    }

    function getServiceDelegate() {
        return [new AnalyticsBackground()];
    }
}