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
        animation.setAnimationTimer();
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
        animation.sleep = false;
        animation.updateAnimationState();
    }


    function onUpdate(dc as Dc) as Void {
        if (Settings.animationSetting) { 
            Log.debug("Animatiion is set on ON");
            ifAnimationOn(dc);
            }
        else{
            Log.debug("Animatiion is set on OFF");
            if (animation.isAnimating) {
                animation.stopAnimation();
            }
            basicUpdate(dc);
        }

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        animation.stopAnimation();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        // not sure if needed
        animation.sleep = false;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
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
    }

    hidden function basicUpdate(dc) as Void {
        animation.drawBackground(dc);
        fields.update_fields(dc);
        Log.debug("Regular Update - No Animation");
    }

}



// todo
// Fetch: HRV, Body Battery, Steps, Active Minutes
// Customize Fields (also enable to delete the field - This is fine for bubble)
// set stress levelthreshold setting
// font in layout file? also x="30%"
// settings, Simulator Settings->Trigger App Settings (Customize) Menu2
// extrend Drawings with extends WatchUi.WatchFace and finoclockView with Drawings

///////////////////////////////////////
// font size this is fine on bubble
// calorie goal setting?
// Fetch body battery, calc % calories, put in both settings