import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

module Settings {
    var smokeSetting;
    var bubbleSetting;
    var cupSetting;
    var heartSetting;
    var stressScoreSetting;
    var caloriesGoal;
    var animationSetting;

    function getProperties(){
        smokeSetting = Application.Properties.getValue("smokeField");
        heartSetting = Application.Properties.getValue("heartField");
        bubbleSetting = Application.Properties.getValue("bubbleField");
        cupSetting = Application.Properties.getValue("cupField");
        stressScoreSetting = Application.Properties.getValue("stressThreshold");
        caloriesGoal = Application.Properties.getValue("caloriesGoal");
        animationSetting = Application.Properties.getValue("animationSetting");
    }

    const fieldsMap = {
        0 => Rez.Strings.none,
        1 => Rez.Strings.heart,
        2 => Rez.Strings.stress,
        3 => Rez.Strings.calories,
        4 => Rez.Strings.date,
        5 => Rez.Strings.time,
        6 => Rez.Strings.thisisfine,
        7 => Rez.Strings.body,
        8 => Rez.Strings.caloriesPerc,
    };

    function getFieldResource(fieldId){
        var fieldResource = fieldsMap.get(fieldId);
        return fieldResource;
    }

    function getFieldString(fieldId) as String{
        Log.debug("getFieldString " + fieldId);
        var fieldResource = getFieldResource(fieldId);
        var fieldString = WatchUi.loadResource(fieldResource);
        return (fieldString != null) ? fieldString : "";
    }

}
