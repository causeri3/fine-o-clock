
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Timer;

module ViewRef { var view = null; }

class finoclockView extends WatchUi.WatchFace{
    private var fields as Fields or Null;
    private var animation as BackgroundAnimation or Null;
    private var sleep;
    private var reloadPending as Boolean = false;
    private var reloadTimer;

    function initialize() {
        WatchFace.initialize();
        fields = new Fields();
        animation = new BackgroundAnimation();
        sleep = false;
        ViewRef.view = self;
    }

    function releaseHeavyResources() as Void {
        // drop the active bitmap. to prevent OOM when menu is loaded        if (animation != null) { animation.stopAnimation(); }
        animation = null;
        reloadPending = true;
    }

    function onReloadReady() as Void {
        reloadPending = false;
        reloadTimer = null;
        WatchUi.requestUpdate();
    }

    function onLayout(dc as Dc) as Void {
        fields.init(dc);
    }


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        Log.showMemoryUsage();
        // After the menu closes, defer the bitmap reload so the GC has time
        if (reloadPending && reloadTimer == null) {
            reloadTimer = new Timer.Timer();
            // 50 is shortest time possible in method, its enough to prevent parallel loaading in memeory
            reloadTimer.start(method(:onReloadReady), 50, false);
        }

        // bugfix, if onShow and in sleep: timer.start() leads to
        // Error: Permission Required
        // Details: "Symbol 'start' not available to 'Watch Face'"
        // animation may be null after returning from settings menu; onUpdate will reload it
        if (sleep != true && animation != null) {
            animation.setAnimationTimer();
            animation.updateAnimationState();
        }
    }


    function onUpdate(dc as Dc) as Void {
            // Log.debug("In onUpdate");
            // Log.showMemoryUsage();

            if (reloadPending) {
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
                dc.clear();
                return;
            }

            if (animation == null) {
                animation = new BackgroundAnimation();
                animation.setAnimationTimer();
                animation.updateAnimationState();
            }
            if (Settings.animationSetting) {
                ifAnimationOn(dc);
            }
            else{
                if (animation.isAnimating) {
                    animation.stopAnimation();
                }
                animation.setStaticStressPicture();
                basicUpdate(dc);
            }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.

    // In Simulator trigger by:  Settings > Force onHide and Settings > Force onShow
    // or juts by caling the menu Settings > Trigger App Settings (here you can see that nothing is being updated)
    function onHide() as Void {
        // needs to be stopped, becuase not triggered by update, but timer
        if (animation != null) { animation.stopAnimation(); }
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    // In Simulator trigger by: Settings > Disply Mode > Always on > Toggle Power Mode (ooff and on)
    function onExitSleep() as Void {
        sleep = false;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        sleep = true;
        if (animation != null) { animation.stopAnimation(); }
    }

    hidden function ifAnimationOn(dc) as Void {
        if (!sleep){
            animation.updateAnimationState();
        }
        // I thought I would be smart by only drawing the background if the timer doesnt do it, 
        // but it led to a black screen for mome milliseconds on the forerunner, fenix and enduro models
        // appearently they clear the screen no mather what on update
        basicUpdate(dc);
    }

    hidden function basicUpdate(dc) as Void {
        animation.drawBackground(dc);
        fields.update_fields(dc);    
        }
}



