import Toybox.Lang;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.System;
import Toybox.Time;
import Toybox.SensorHistory;


function getHeartRate() as Number or Null{
    var heartRate = null;
    // real-time data
    var info = Activity.getActivityInfo();
    if (info != null && info.currentHeartRate != null) {
        heartRate = info.currentHeartRate;
        //Log.debug("HR from ActivityMonitor: " + heartRate);
        return heartRate;
    }

    // fall back to heart rate history if no current HR, 
    // get last sample, working with Time.Duration led to crashes, stopped digging deeper
    // var hrIterator = ActivityMonitor.getHeartRateHistory(Time.Duration(6, true);
    var hrIterator = ActivityMonitor.getHeartRateHistory(1, true);
    var sample = hrIterator.next();
    if (sample != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
        heartRate = sample.heartRate;
        //Log.debug("HR from HeartRateHistory: " + heartRate);
        return heartRate;
    }

    return heartRate;
}

function getActiveMinutes() as Number or Null{
    var activityInfo = ActivityMonitor.getInfo();
    var activeMinutes = activityInfo.activeMinutesWeek;
    return (activeMinutes != null) ? activeMinutes.total : null;
}


function getSteps() as Number or Null{
    var activityInfo = ActivityMonitor.getInfo();
    var steps = activityInfo.steps;
    return steps;
}


function getStepsProgress() as Number or Null {
    var goal = Settings.stepsGoal;
    var steps = getSteps();

    if (goal > 0 && steps != null) {
        var progress = steps.toFloat() / goal.toFloat();

        return (progress > 1.0) ? 100 : (progress * 100);
    }
    return 0; 
}


function getBatteryLevel() as Float {
    var stats = System.getSystemStats();
    var battery = stats.battery;
    return battery;
}


function getStressLevel() as Number or Null {
    // var value = "55";
    // return value;

    var stressLevel = null;
    
    // real-time data
    // API Level 5.0.0 - not for e.g. descentmk2s
    if (ActivityMonitor.Info has :stressScore) {
        var activityInfo = ActivityMonitor.getInfo();

    if (activityInfo.stressScore != null) {
        stressLevel = activityInfo.stressScore;
        //Log.debug("Stress from ActivityMonitor: " + stressLevel);

        return stressLevel;
        }
    }
    
    // fall back to sensor history - takes around 3 min to update value
    if (stressLevel == null) {
        stressLevel = getLatestStressLevelFromSensorHistory();
        //Log.debug("Stress from SensorHistory: " + stressLevel);

        return stressLevel;
    }
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
    

function getLatestStressLevelFromSensorHistory() as Number or Null {
    // takes mostly plus minus 3 minutes to get a new stress value
    var stressIterator = getStressIterator();
    if (stressIterator == null) {
        return null;
    }
    var sample = stressIterator.next();  
    return (sample != null && sample.data != null) ? sample.data : null;
}


// workaround so the weekday stays English 
// and I dont have to provide all characters of all possible languages in the Garmin watch Setting
function numericToStringWeekDay(weekday as Number) as String {
    var weekDaysString = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return weekDaysString[weekday-1];
}


function getDate() as String {
    var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var dateString = Lang.format(
        "$1$ $2$",
        [numericToStringWeekDay(now.day_of_week), now.day]
        );
    return dateString;
}


function getTime() as String {
    var clockTime = System.getClockTime();
    var settings = System.getDeviceSettings();

    if (settings.is24Hour) {
        return Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
    } else {
        var hour12 = clockTime.hour % 12;
        if (hour12 == 0) {
            hour12 = 12;
        }
        return Lang.format("$1$:$2$", [hour12, clockTime.min.format("%02d")]);
    }
}


function getCalories() as Number or Null {
    var activityInfo = ActivityMonitor.getInfo();
    return activityInfo.calories;
}


function getBodyIterator(period as Time.Duration?) {
    if ((Toybox has :SensorHistory) && (SensorHistory has :getBodyBatteryHistory)) {
        return SensorHistory.getBodyBatteryHistory({
            :period => period,
            :order => SensorHistory.ORDER_NEWEST_FIRST
        });
    }
    return null;
}


function getBodyBattery() as Number or Null {
    // crashed on descentmk2s between 12h/24h OOM
    var durations = [
        new Time.Duration(60 * 30),         // 30 minutes
        new Time.Duration(60 * 60),         // 1 hour
        new Time.Duration(60 * 60 * 6),     // 6 hours
        // it seems to me as after 6h the old body battery value lost its meaning completely
    ];

    for (var i = 0; i < durations.size(); i++) {
        //Log.debug("Duration Minutes: " + (durations[i].value() /60));
        //if (i > 0) {Log.debug("Duration Minutes: " + (durations[i].value() /60));}
        var duration = durations[i];
        var bbIterator = getBodyIterator(duration);

        if (bbIterator == null) {
            continue;
        }

        var sample = bbIterator.next();
        while (sample != null) {
            if (sample.data != null && sample.data.toNumber() != null) {
                return sample.data.toNumber();
            }
            sample = bbIterator.next();
        }
    }

    return null; 
}


function getCaloriesProgress() as Number or Null {
    var goal = Settings.caloriesGoal;
    var calories = getCalories();

    if (goal > 0 && calories != null) {
        var progress = calories.toFloat() / goal.toFloat();

        return (progress > 1.0) ? 100 : (progress * 100); 
    }
    return 0; 
}


function reformatToString(value) as String {
    if (value instanceof Lang.String) {
        return value; 
        }
    if (value == null) {
        return "";
    }
    return value.format("%.0f"); // round not only format
}
