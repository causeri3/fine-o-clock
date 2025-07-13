
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class finoclockView extends WatchUi.WatchFace{
    private var fields as Fields;
    private var animation as BackgroundAnimation;
    private var sleep;

    function initialize() {
        WatchFace.initialize();
        // Fields.initialize();
        fields = new Fields();
        animation = new BackgroundAnimation();
        sleep = false;
        Log.debug("finoclockView initialized");

    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        fields.init(dc);
        //setLayout(Rez.Layouts.WatchFace(dc));
    }


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        Log.debug("In onShow");
        // bugfix, if onShow and in sleep: timer.start() leads to 
        // Error: Permission Required
        // Details: "Symbol 'start' not available to 'Watch Face'"
        if (sleep != true) {
            animation.setAnimationTimer();
            animation.updateAnimationState();
        }
    }


    function onUpdate(dc as Dc) as Void {
            if (Settings.animationSetting) { 
                Log.debug("Animation is set on ON");
                ifAnimationOn(dc);
            }
            else{
                Log.debug("Animation is set on OFF");
                if (animation.isAnimating) {
                    animation.stopAnimation();
                }
                basicUpdate(dc);
            }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    // In Simulator trigger by:  Settings > Force onHide and Settings > Force onShow
    // or juts by caling the menu Settings > Trigger App Settings (here you can see that nothing is being updated)
    function onHide() as Void {
        Log.debug("In onHide");
        // needs to be stopped, becuase not triggered by update, but timer
        animation.stopAnimation();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    // In Simulator trigger by: Settings > Disply Mode > Always on > Toggle Power Mode (ooff and on)
    function onExitSleep() as Void {
        Log.debug("onExitSleep");
        sleep = false;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        Log.debug("onEnterSleep");
        sleep = true;
        animation.stopAnimation();
    }

    hidden function ifAnimationOn(dc) as Void {
        if(animation.timerTriggered && animation.isAnimating){
            animation.drawBackground(dc);
            fields.update_fields(dc);
            Log.debug("Timer Triggered Update - Animation");
            animation.timerTriggered = false;
        }
        else if((!animation.timerTriggered && !animation.isAnimating) || sleep){
            basicUpdate(dc);
        }
        else{
            Log.debug("Don't Update - Animation Runs on Timer");
        }

        if (!sleep){
            animation.updateAnimationState();
        }
        else{
            Log.debug("Animation is stopped due to sleep");
        }
    }

    hidden function basicUpdate(dc) as Void {
        animation.drawBackground(dc);
        fields.update_fields(dc);
        Log.debug("Regular Update - No Animation");
    }

}



