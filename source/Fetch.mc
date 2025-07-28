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

function getActiveMinutes() as String {
    var activityInfo = ActivityMonitor.getInfo();
    var activeMinutes = activityInfo.activeMinutesWeek.total;
    if (activeMinutes == null) {return "";}
    return activeMinutes.format("%i");
}


function getSteps() as String {
    var activityInfo = ActivityMonitor.getInfo();
    var steps = activityInfo.steps.format("%i");
    if (steps == null) {return "";}
    return steps;
}


function getStepsProgress() as Number{
    var goal = Settings.stepsGoal;
    var steps = getSteps();

    if (goal > 0 && steps != null) {
        var progress = steps.toFloat() / goal.toFloat();

        return (progress > 1.0) ? 100 : (progress * 100).format("%.0f"); // round not only format
    }
    return 0; 
}

function getBatteryLevel() as String {
    var stats = System.getSystemStats();
    var battery = stats.battery;
    return (battery != null) ? battery.format("%i") : "";
}

function getStressLevel() as String {
    // var value = "55";
    // return value;

    var stressLevel = null;
    
    // real-time data
    // API Level 5.0.0 - not for e.g. descentmk2s
    if (ActivityMonitor.Info has :stressScore) {
        var activityInfo = ActivityMonitor.getInfo();

    if (activityInfo.stressScore != null) {
        stressLevel = activityInfo.stressScore;
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
    var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
    return timeString;
}


function getCalories() as String {
    var activityInfo = ActivityMonitor.getInfo();
    return activityInfo.calories.format("%i");
}

// still testing
// function getBodyIterator(period as Time.Duration?) {
//     if ((Toybox has :SensorHistory) && (SensorHistory has :getBodyBatteryHistory)) {
//         return SensorHistory.getBodyBatteryHistory({
//             :period => period,
//             :order => SensorHistory.ORDER_NEWEST_FIRST
//         });
//     }
//     return null;
// }

// function getBodyBattery() as String {
//     var durations = [
//         new Time.Duration(60 * 30),         // 30 minutes
//         new Time.Duration(60 * 60),         // 1 hour
//         new Time.Duration(60 * 60 * 2),     // 2 hours
//         new Time.Duration(60 * 60 *34)      // 1 day
//     ];

//     for (var i = 0; i < durations.size(); i++) {
//         var duration = durations[i];
//         var bbIterator = getBodyIterator(duration);

//         if (bbIterator == null) {
//             continue;
//         }

//         var sample = bbIterator.next();
//         while (sample != null) {
//             if (sample.data != null && sample.data.toNumber() != null) {
//                 return sample.data.toNumber().format("%d");
//             }
//             sample = bbIterator.next();
//         }
//     }

//     return ""; // fallback if nothing found
// }



function getBodyBattery() as String {
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


function getCaloriesProgress() as String {
    var goal = Settings.caloriesGoal;
    var calories = getCalories();

    if (goal > 0 && calories != null) {
        var progress = calories.toFloat() / goal.toFloat();

        return (progress > 1.0) ? 100.format("%i") : (progress * 100).format("%.0f"); // round not only format
    }
    return 0.format("%i"); 
}
