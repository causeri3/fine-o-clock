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

    function drawBattery(dc as Dc) {
        var stats = System.getSystemStats();
        var battery = stats.battery;
    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    
        var x = 30;
        var y = 65;
        var w_body = 20;
        var h_body = 10;
        var w_tip = 2;
        var h_tip = 6;
        dc.drawRectangle(x, y, w_body, h_body);  // battery body
        dc.drawRectangle(x + w_body, y + w_tip, w_tip, h_tip);    // battery tip
    
        // Fill battery level in different color
        if (battery <= 20) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        var fillWidth = (battery / 100.0) * 18;  // Scale battery level to fit
        dc.fillRectangle(x + 1, y + 1, fillWidth, h_body - 2);
    }


    function initialize() {
        WatchFace.initialize();
        // background image
        mBackground = Application.loadResource(Rez.Drawables.Meme) as BitmapResource;
        // font
        TIFFontLarge = WatchUi.loadResource(Rez.Fonts.TIFFontLarge);
        TIFFontTiny = WatchUi.loadResource(Rez.Fonts.TIFFontTiny);

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


    function drawHeartRate(dc as Dc) as Void {
      var heartRate = getHeartRate();
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      dc.drawText(111, 133, TIFFontTiny, "♥", Graphics.TEXT_JUSTIFY_RIGHT);
      dc.drawText(116, 146, TIFFontTiny, heartRate, Graphics.TEXT_JUSTIFY_RIGHT);

    }

    function drawStressLevel(dc as Dc) as Void {
      var stressLevel = getStressLevel();
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      dc.drawText(185, 140, TIFFontTiny, stressLevel, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onUpdate(dc as Dc) as Void {

        // background 
        dc.drawBitmap(0, 0, mBackground);
        // time 
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        // (240x240 screen = center at 120,120)
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(133, 30, TIFFontLarge, timeString, Graphics.TEXT_JUSTIFY_CENTER);

        // date
        var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format(
            "$1$ $2$",
            [now.day_of_week, now.day]
            );
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(120, 6, TIFFontTiny, dateString, Graphics.TEXT_JUSTIFY_CENTER);


        drawHeartRate(dc);
        drawStressLevel(dc);
        drawBattery(dc);

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