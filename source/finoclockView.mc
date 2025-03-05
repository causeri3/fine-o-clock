import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;
import Toybox.Time.Gregorian;

class finoclockView extends WatchUi.WatchFace {
    private var mBackground as BitmapResource?;   
    private var TIFFontLarge;      
    private var TIFFontTiny;  
    private var drawings as Drawings;


    function initialize() {
        WatchFace.initialize();
        // background image
        mBackground = Application.loadResource(Rez.Drawables.Meme) as BitmapResource;
        // font
        // TIFFontLarge = WatchUi.loadResource(Rez.Fonts.TIFFontLarge);
        // TIFFontTiny = WatchUi.loadResource(Rez.Fonts.TIFFontTiny);
        drawings = new Drawings();

    }


    // Load your resources here
    // function onLayout(dc as Dc) as Void {
    //     setLayout(Rez.Layouts.WatchFace(dc));
    // }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        // background 
        dc.drawBitmap(0, 0, mBackground);

        drawings.drawTime(dc);
        drawings.drawDate(dc);
        drawings.drawHeartRate(dc);
        drawings.drawStressLevel(dc);
        drawings.drawBattery(dc);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        // mBackground = null; // depends if I want the picture stay loaded in memory while other functions or delete and reload - trade off
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}



// todo
// clock in layout file?
// settings?