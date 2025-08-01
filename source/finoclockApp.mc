import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class finoclockApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
        Log.debug("AppBase initialized");

    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new finoclockView() ];
    }
    
    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void{
        Settings.getProperties();
        WatchUi.requestUpdate();
    }

    function getSettingsView() {
        return [new Menu(), new MenuDelegate()];
    }
}