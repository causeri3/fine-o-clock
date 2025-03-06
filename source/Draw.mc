import Toybox.Graphics;


class Drawings{
    private var TIFFontTiny = WatchUi.loadResource(Rez.Fonts.TIFFontTiny);
    private var TIFFontLarge = WatchUi.loadResource(Rez.Fonts.TIFFontLarge);
    var x; 
    var y; 

    function init(dc as Dc) as Void {
        x = dc.getWidth(); 
        y = dc.getHeight(); 
    }

    function drawHeart(dc as Dc) as Void {
      var heartRate = getHeartRate();
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      dc.drawText(.46*x, .55*y, TIFFontTiny, "♥", Graphics.TEXT_JUSTIFY_RIGHT);
      dc.drawText(.48*x, .6*y, TIFFontTiny, heartRate, Graphics.TEXT_JUSTIFY_RIGHT);

    }

    function drawCup(dc as Dc) as Void {
      var stressLevel = getStressLevel();
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      dc.drawText(.76*x, .58*y, TIFFontTiny, stressLevel, Graphics.TEXT_JUSTIFY_CENTER);
    }


    function drawBattery(dc as Dc) as Void {
        var stats = System.getSystemStats();
        var battery = stats.battery;
    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    
        var _x = .125*x;
        var _y = .27*y;
        var w_body = .08*x;
        var h_body = .04*y;
        var w_tip = .008*x;
        var h_tip = .025*y;
        dc.drawRectangle(_x, _y, w_body, h_body);  // battery body
        dc.drawRectangle(_x + w_body, _y + w_tip, w_tip, h_tip);    // battery tip
    
        // Fill battery level in different color
        if (battery <= 20) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        var fillWidth = (battery / 100.0) * 18;  // Scale battery level to fit
        dc.fillRectangle(_x + 1, _y + 1, fillWidth, h_body - 2);
    }
    
    function drawBubble(dc as Dc) {
        var time = getTime();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(.55*x, .125*y, TIFFontLarge, time, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawClouds(dc as Dc) as Void {
        var date = getDate();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(0.5*x, .025*y, TIFFontTiny, date, Graphics.TEXT_JUSTIFY_CENTER);
    }
}