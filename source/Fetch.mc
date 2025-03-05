import Toybox.Lang;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Time.Gregorian;
import Toybox.System;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;



function getHeartRate() as String {
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


function getStressLevel() as String {
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
    // get only last value, array would be posisble here, stress gives often null back,
    // array would mean more values to fall back, so less empty field and longer updating time
        return Toybox.SensorHistory.getStressHistory({:period => 1});
    }
    return null;
}
    

function getLatestStressLevelFromSensorHistory() as String {
    // takes mostly plus minus 3 minutes to get a new stress value
    var stressIterator = getStressIterator();
    var sample = stressIterator.next();  
    return (sample != null && sample.data != null) ? sample.data.format("%i") : "";
}


function getDate() as String {
    var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    var dateString = Lang.format(
        "$1$ $2$",
        [now.day_of_week, now.day]
        );
    return dateString;
}

function getTime() as String {
    var clockTime = System.getClockTime();
    var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
    return timeString;
}