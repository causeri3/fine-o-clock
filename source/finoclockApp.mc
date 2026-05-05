
import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Background;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class finoclockApp extends Application.AppBase {
    var analytics as Analytics;

    function initialize() {
        AppBase.initialize();
        analytics = new Analytics();
    }


    function onStart(state as Dictionary?) as Void {
        System.println("App onStart");

        var settings = System.getDeviceSettings();
        Storage.setValue("deviceId", settings.uniqueIdentifier);
        Storage.setValue("partNumber", settings.partNumber);

        // fire every six hours, to check if this day was used
        //Background.registerForTemporalEvent(new Time.Duration(6 * 60 * 60));
        // fire every 5 minutes for testing
        Background.registerForTemporalEvent(new Time.Duration(5*60));
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
        //Log.debug("Settings changed");
        Settings.getProperties();
        Log.debug("BEFORE trackin settings");
        Log.showMemoryUsage();
        analytics.track("settings", 
        // they both crashed with OOM, but sometimes some settings went through. Counldt reproduce though
        Settings.getPropertiesAsString()
        //"str: smokeField:3|bubbleField:5|cupField:2|bodyField:1|batteryField:12|stressThreshold:50|caloriesGoal:2000|stepsGoal:10000|animationSetting:true|basePicFireSetting:false"
        );
        Log.debug("AFTER trackin settings");
        Log.showMemoryUsage();
        WatchUi.requestUpdate();
    }

    function getSettingsView() {
        return [new Menu(), new MenuDelegate()];
    }

    function getServiceDelegate() {
        return [new AnalyticsBackground()];
    }

    function onBackgroundData(data as Application.PersistableType) as Void {
    }
}