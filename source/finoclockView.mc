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

    private function getHeartRate() as String {
        var heartRate = null;
        // real-time data
        var info = Activity.getActivityInfo();
        if (info != null && info.currentHeartRate != null) {
            heartRate = info.currentHeartRate.format("%i");
            Log.debug("HR from ActivityMonitor: " + heartRate);
            return heartRate;
        }

        // fall back to heart rate history if no current HR, 
        // get last sample, working with Time.Duration led to crashes, stopped digging deeper
        // var hrIterator = ActivityMonitor.getHeartRateHistory(Time.Duration(6, true);

        var hrIterator = ActivityMonitor.getHeartRateHistory(1, true);
        var sample = hrIterator.next();
        if (sample != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
            heartRate = sample.heartRate.format("%i");
            Log.debug("HR from getHeartRateHistory: " + heartRate);
            return heartRate;
        }

        return "";
    }

    function drawStressLevel(dc as Dc) as Void {
      var stressLevel = getStressLevel();
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      dc.drawText(185, 140, TIFFontTiny, stressLevel, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function getStressLevel() as String {
        var stressLevel = null;
    
        // real-time data
        // API Level 5.0.0 - not for e.g. descentmk2s
        if (ActivityMonitor.Info has :stressScore) {
        var activityInfo = ActivityMonitor.getInfo();

        if (activityInfo.stressScore != null) {
            stressLevel = activityInfo.stressScore.toDouble();
            Log.debug("Stress from ActivityMonitor: " + stressLevel);

            return stressLevel.format("%i");
            }
        }
    
        // fall back to sensor history - takes around 3 min to update value
        if (stressLevel == null) {
        stressLevel = getLatestStressLevelFromSensorHistory();
        Log.debug("Stress from SensorHistory: " + stressLevel);

        return stressLevel;
        }
        return "";
    }

    function getStressIterator() {
      // Check device for SensorHistory compatibility
      if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)) {
          return Toybox.SensorHistory.getStressHistory({:period => 1});
      }
      return null;
    }
    

    private function getLatestStressLevelFromSensorHistory() as String {
        // takes mostly plus minus 3 minutes to get a new stress value
        var stressIterator = getStressIterator();
        var sample = stressIterator.next();  
       return (sample != null && sample.data != null) ? sample.data.format("%i") : "";
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
// functions in sperate file
// settings?
// clean up drawables folder
// own launcher icon?
// date
// an screen lighten up? - double check implementation on device - didnt work
