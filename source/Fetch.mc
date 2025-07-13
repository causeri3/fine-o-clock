import Toybox.Lang;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.System;
import Toybox.Time;
import Toybox.SensorHistory;


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
    // Not sure if it is needed - just more safety
    if (hrIterator == null) {
        return "";
        }
    var sample = hrIterator.next();
    if (sample != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
        heartRate = sample.heartRate.format("%i");
        Log.debug("HR from HeartRateHistory: " + heartRate);
        return heartRate;
    }

    return "";
}


function getStressLevel() as String {

    //return = "55";

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
    if ((Toybox has :SensorHistory) && (SensorHistory has :getStressHistory)) {
    // get only last value, array would be posisble here, stress gives often null back,
    // array would mean more values to fall back, so less empty field and longer updating time
        return Toybox.SensorHistory.getStressHistory({:period => 1});
    }
    return null;
}
    

function getLatestStressLevelFromSensorHistory() as String {
    // takes mostly plus minus 3 minutes to get a new stress value
    var stressIterator = getStressIterator();
    if (stressIterator == null) {
        return "";
    }
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


function getCalories() {
    var activityInfo = ActivityMonitor.getInfo();
    return activityInfo.calories; //.toDouble();
}


function getBodyBattery() {
    var bodyBattery = null;
    if (Toybox has :SensorHistory && SensorHistory has :getBodyBatteryHistory) {
        var iterator = SensorHistory.getBodyBatteryHistory({ :period => 1 });
        if (iterator != null) {
            bodyBattery = iterator.next();    
        }
    }
    if (bodyBattery != null) {
        bodyBattery = bodyBattery.data.format("%i");
        return bodyBattery;
    }
    return "";
}


function getCaloriesProgress() {
    var goal = Settings.caloriesGoal;
    var calories = getCalories();

    if (goal > 0 && calories != null) {
        var progress = calories.toFloat() / goal.toFloat();

        return (progress > 1.0) ? 100 : (progress * 100).format("%.0f"); // round not only format
    }
    return 0; 
}
