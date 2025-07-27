import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;



class Fields{
    private var TIFFontSmall;
    private var TIFFontLarge;
    private var TIFFontTiny;
    private var x; 
    private var y; 

    //   function initialize() {
    //     WatchFace.initialize();
    // }


    function init(dc as Dc){
        // Log.debug("BEFORE FONT LOADING");
        // Log.showMemoryUsage();

        TIFFontSmall = WatchUi.loadResource(Rez.Fonts.TIFFontSmall);
        TIFFontLarge = WatchUi.loadResource(Rez.Fonts.TIFFontLarge);
        TIFFontTiny = WatchUi.loadResource(Rez.Fonts.TIFFontTiny);

        // Log.debug("AFTER FONT LOADING");
        // Log.showMemoryUsage();

        x = dc.getWidth(); 
        y = dc.getHeight(); 
        Settings.getProperties();
    }

    function drawBody(dc as Dc) as Void {

        //var heartRate = getHeartRate();
        var bodySettingString = Settings.getFieldString(Settings.bodySetting);
        var bodyValue = choose_field(bodySettingString);
        if (bodyValue.equals("")) {
        } 
        else {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        Log.debug("bodySettingString" + bodySettingString);
        if (bodySettingString.equals("Heart Rate")){
        dc.drawText(.46*x, .55*y, TIFFontSmall, "♥", Graphics.TEXT_JUSTIFY_RIGHT);
        }
        dc.drawText(.48*x, .6*y, TIFFontSmall, bodyValue, Graphics.TEXT_JUSTIFY_RIGHT);
        }

    }

    function drawCup(dc as Dc) as Void {
        var cupSettingString = Settings.getFieldString(Settings.cupSetting);
        var cupValue = choose_field(cupSettingString);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(.76*x, .58*y, TIFFontSmall, cupValue, Graphics.TEXT_JUSTIFY_CENTER);
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
        var fillWidth = (battery / 100.0) * w_body;  // Scale battery level to fit
        dc.fillRectangle(_x + 1, _y + 1, fillWidth, h_body - 2);
    }
    
    function drawBubble(dc as Dc) {
        var bubbleSettingString = Settings.getFieldString(Settings.bubbleSetting);
        var bubbleValue = choose_field(bubbleSettingString);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        if (bubbleValue.equals("This is Fine")) {
            dc.drawText(.55*x, .165*y, TIFFontTiny, bubbleValue, Graphics.TEXT_JUSTIFY_CENTER);
        }
        else {
            dc.drawText(.55*x, .125*y, TIFFontLarge, bubbleValue, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    function drawSmoke(dc as Dc) as Void {
        var smokeSettingString = Settings.getFieldString(Settings.smokeSetting);
        var smokeValue = choose_field(smokeSettingString);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        if (smokeValue.equals("This is Fine")) {
            dc.drawText(0.55*x, .045*y, TIFFontTiny, smokeValue, Graphics.TEXT_JUSTIFY_CENTER);
        }
        else {
            dc.drawText(0.5*x, .025*y, TIFFontSmall, smokeValue, Graphics.TEXT_JUSTIFY_CENTER);
        }

    }

    function choose_field(settingString) as String{
        var settingValue;
        
        if (settingString.equals("Calories")) {
            settingValue = getCalories().toString();
        } 
        else if (settingString.equals("Stress Level")) {
            settingValue = getStressLevel();
        }
        else if (settingString.equals("Battery Level")) {
            settingValue = getBatteryLevel();
        }
        else if (settingString.equals("Body Battery")) {
            settingValue = getBodyBattery();
        }
        else if (settingString.equals("Calories Percentage")) {
            settingValue = getCaloriesProgress();
        }
        else if (settingString.equals("Date")) {
            settingValue = getDate();
        }
        else if (settingString.equals("Time")) {
            settingValue = getTime();
        }
        else if (settingString.equals("This is Fine")) {
            settingValue = "This is Fine";
        }
        else if (settingString.equals("Heart Rate")) {
            settingValue = getHeartRate();
        }
        else if (settingString.equals("Active Minutes This Week")) {
            settingValue = getActiveMinutes();
        }
        else if (settingString.equals("Steps")) {
            settingValue = getSteps();
        }
        else if (settingString.equals("Steps Percentage")) {
            settingValue = getStepsProgress();
        }
        else if (settingString.equals("None")) {
            settingValue = "";
        }
        else {
            settingValue = "";
        }
        return settingValue;
    }

    function update_fields(dc as Dc) as Void{
        drawBubble(dc);
        drawSmoke(dc);
        drawBody(dc);
        drawCup(dc);
        if (Settings.batterySetting) { 
            drawBattery(dc);
        }
    }
}