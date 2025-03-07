import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Lang;


class finoclockView extends WatchUi.WatchFace {
    private var drawings as Drawings;
    private var animation as BackgroundAnimation;



    function initialize() {
        drawings = new Drawings();
        animation = new BackgroundAnimation();
        animation.setAnimationTimer();
    }


    // Load your resources here
    function onLayout(dc as Dc) as Void {
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

    function update_drawings(dc as Dc)as Void{
        animation.drawBackground(dc);
        drawings.init(dc);
        drawings.drawBubble(dc);
        drawings.drawClouds(dc);
        drawings.drawHeart(dc);
        drawings.drawCup(dc);
        drawings.drawBattery(dc);
    }


    function onUpdate(dc as Dc) as Void {
        if(animation.timerTriggered && animation.isAnimating){
            update_drawings(dc);
            Log.debug("timerTriggered Update");
            animation.timerTriggered = false;
        }
        else if((!animation.timerTriggered && !animation.isAnimating) || animation.sleep){
            update_drawings(dc);
            Log.debug("Regular Update");
        }
        else{
            Log.debug("DONT UPDATE");
        }

        if (!animation.sleep){
            animation.updateAnimationState();
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

}



// todo
// clock in layout file?
// settings?