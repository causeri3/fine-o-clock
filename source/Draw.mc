import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;
import Toybox.Time.Gregorian;

class Drawings{
    private var TIFFontTiny = WatchUi.loadResource(Rez.Fonts.TIFFontTiny);
    private var TIFFontLarge = WatchUi.loadResource(Rez.Fonts.TIFFontLarge);   
  
    //var dc = new Dc();

    function drawHeartRate(dc as Dc) as Void {
      var heartRate = getHeartRate();
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      dc.drawText(111, 133, TIFFontTiny, "♥", Graphics.TEXT_JUSTIFY_RIGHT);
      dc.drawText(116, 146, TIFFontTiny, heartRate, Graphics.TEXT_JUSTIFY_RIGHT);

    }

    function drawStressLevel(dc as Dc) as Void {
      var stressLevel = getStressLevel();
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      dc.drawText(182, 140, TIFFontTiny, stressLevel, Graphics.TEXT_JUSTIFY_CENTER);
    }


    function drawBattery(dc as Dc) as Void {
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
    
    function drawTime(dc as Dc) {
        // var clockTime = System.getClockTime();
        // var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        // (240x240 screen = center at 120,120)
        var time = getTime();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(133, 30, TIFFontLarge, time, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawDate(dc as Dc) as Void {
        var date = getDate();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(120, 6, TIFFontTiny, date, Graphics.TEXT_JUSTIFY_CENTER);
    }
}