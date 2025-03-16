import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

module Settings {
    var smokeSetting;
    var bubbleSetting;
    var cupSetting;
    var stressScoreSetting;
    var caloriesGoal;

    function getProperties(){
        smokeSetting = Application.Properties.getValue("smokeField");
        bubbleSetting = Application.Properties.getValue("bubbleField");
        cupSetting = Application.Properties.getValue("cupField");
        stressScoreSetting = Application.Properties.getValue("stressThreshold");
        caloriesGoal = Application.Properties.getValue("caloriesGoal");
    }

    const stressThresholds = {
        0 => Rez.Strings.none,
        1 => Rez.Strings.stress,
        2 => Rez.Strings.calories,
        3 => Rez.Strings.date,
        4 => Rez.Strings.time,
        5 => Rez.Strings.thisisfine,

    const fieldsMap = {
        0 => Rez.Strings.none,
        1 => Rez.Strings.stress,
        2 => Rez.Strings.calories,
        3 => Rez.Strings.date,
        4 => Rez.Strings.time,
        5 => Rez.Strings.thisisfine,
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
