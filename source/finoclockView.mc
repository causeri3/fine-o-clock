
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class finoclockView extends WatchUi.WatchFace{
    private var fields as Fields;
    private var animation as BackgroundAnimation;

    function initialize() {
        // Fields.initialize();
        fields = new Fields();
        animation = new BackgroundAnimation();
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
    }


    function onUpdate(dc as Dc) as Void {
        if (Settings.animationSetting) { 
            //Log.debug("Animation is set on ON");
            ifAnimationOn(dc);
            }
        else{
            //Log.debug("Animation is set on OFF");
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
    function onHide() as Void {
        Log.debug("In onHide");
        animation.stopAnimation();
        animation.sleep = true;
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    // In Simulator trigger by: Settings > Disply Mode > Always on > Toggle Power Mode (ooff and on)
    function onExitSleep() as Void {
        Log.debug("onExitSleep");
        animation.setAnimationTimer();
        animation.sleep = false;
        animation.updateAnimationState();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        Log.debug("onEnterSleep");
        animation.sleep = true;
        animation.stopAnimation();
    }

    hidden function ifAnimationOn(dc) as Void {
        if(animation.timerTriggered && animation.isAnimating){
            animation.drawBackground(dc);
            fields.update_fields(dc);
            Log.debug("Timer Triggered Update - Animation");
            animation.timerTriggered = false;
        }
        else if((!animation.timerTriggered && !animation.isAnimating) || animation.sleep){
            basicUpdate(dc);
        }
        else{
            Log.debug("Don't Update - Animation Runs on Timer");
        }

        if (!animation.sleep){
            animation.updateAnimationState();
        }
        else{
            Log.debug("Animation is set to sleep");
        }
    }

    hidden function basicUpdate(dc) as Void {
        animation.drawBackground(dc);
        fields.update_fields(dc);
        Log.debug("Regular Update - No Animation");
    }

}



