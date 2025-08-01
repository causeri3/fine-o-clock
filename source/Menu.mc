import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class Menu extends WatchUi.Menu2 {

  function initialize() {
    Menu2.initialize({ :title => "Settings"});
    add_items();
  }

  function add_items() {     
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.smokeField, // label
            Settings.getFieldString(Settings.smokeSetting), // sublabel
            "smokeField", // id
            {} // options
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.bubbleField,
            Settings.getFieldString(Settings.bubbleSetting),
            "bubbleField",
            {}
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.cupField, 
            Settings.getFieldString(Settings.cupSetting), 
            "cupField", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.bodyField, 
            Settings.getFieldString(Settings.bodySetting), 
            "bodyField", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.stressThreshold, 
            Settings.stressScoreSetting.toString(), 
            "stressThreshold", 
            {} 
        )
    );
    Menu2.addItem(
        new MenuItem(
            Rez.Strings.caloriesGoal, 
            Settings.caloriesGoal.toString(),
            "caloriesGoal", 
            {} 
        )
    );
      Menu2.addItem(
        new MenuItem(
            Rez.Strings.stepsGoal, 
            Settings.stepsGoal.toString(),
            "stepsGoal", 
            {} 
        )
    );
     Menu2.addItem(                                                                                                   
         new MenuItem(                                                                                                
             Rez.Strings.animationSetting,                                                              
             Settings.animationSetting ? Rez.Strings.on : Rez.Strings.off,                     
             "animationSetting",                                                                                      
             {}                                                                                                       
         )                                                                                                            
     ); 
    Menu2.addItem(                                                                                                   
         new MenuItem(                                                                                                
          Rez.Strings.batterySetting,                                                              
          Settings.batterySetting ? Rez.Strings.on : Rez.Strings.off,                     
          "batterySetting",                                                                                      
          {}                                                                                                       
         )                                                                                                            
     ); 
    Menu2.addItem(                                                                                                   
      new MenuItem(                                                                                                
        Rez.Strings.basePicFireSetting,                                                              
             Settings.basePicFireSetting ? Rez.Strings.on : Rez.Strings.off,                     
             "basePicFireSetting",                                                                                      
             {}                                                                                                       
         )                                                                                                            
     ); 
  }                                                                                                       
}

class MenuDelegate extends WatchUi.Menu2InputDelegate {

  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item) {
    var id = item.getId();
    if (id.equals("smokeField")) {
      cycleFields(Settings.smokeSetting, item, id, null);
    }
    else if (id.equals("bubbleField")) {
      cycleFields(Settings.bubbleSetting, item, id, null);
    }
    else if (id.equals("cupField")) {
      var validKeys = [0, 1, 2, 7, 8, 9, 12]; // only none, heart rate, stress, body battery, % calories, % steps, battery level    

      cycleFields(Settings.cupSetting, item, id, validKeys);
    }
    else if (id.equals("bodyField")) {
      var validKeys = [0, 1, 2, 7, 8, 9, 12]; // only none, heart rate, stress, body battery, % calories, % steps, battery level    
      cycleFields(Settings.bodySetting, item, id, validKeys);
    }
    else if (id.equals("stressThreshold")) {                                                                      
       cycleNumbers(Settings.stressScoreSetting, item, id, 10, 110);                                                                             
     }
    else if (id.equals("caloriesGoal")) {                                                                      
       cycleNumbers(Settings.caloriesGoal, item, id, 100, 10100);                                                                     
     }
      else if (id.equals("stepsGoal")) {                                                                      
       cycleNumbers(Settings.stepsGoal, item, id, 1000, 101000);                                                                     
     }
    else if (id.equals("animationSetting")) {                                                                        
       toggleAnimation(item);                                                                                         
     }      
    else if (id.equals("batterySetting")) {                                                                        
       toggleBattery(item);                                                                                         
     }    
    else if (id.equals("basePicFireSetting")) {                                                                        
       toggleBasePic(item);                                                                                         
     }    

     
  }

//var validKeys as Null or Array<Number> = null;

  hidden function cycleFields(setting, item, fieldId, validKeys){
    if (validKeys == null) {                                                 
           validKeys = Settings.fieldsMap.keys();                               
    }     
    var currentIndex = validKeys.indexOf(setting);
    var nextIndex = (currentIndex + 1) % validKeys.size();
    // make compiler happy by giving container type
    var keys = validKeys as Array<Number>;
    setting = keys[nextIndex]; 
    item.setSubLabel(Settings.getFieldString(setting));
    Application.Properties.setValue(fieldId, setting);
    Settings.getProperties();
  }

  hidden function cycleNumbers(setting, item, fieldId, step, max){                                                            
     var currentValue = setting;                                                           
     var nextValue = (currentValue + step) % max;
     item.setSubLabel(nextValue.toString());                                                                   
     Application.Properties.setValue(fieldId, nextValue);                                                      
     Settings.getProperties();                                                                                     
   } 

  hidden function toggleAnimation(item){                                                                             
     Settings.animationSetting = !Settings.animationSetting;                                                                
     item.setSubLabel(Settings.animationSetting ? Rez.Strings.on : Rez.Strings.off);                                     
     Application.Properties.setValue("animationSetting", Settings.animationSetting);                                        
     Settings.getProperties();
     }   
  hidden function toggleBattery(item){                                                                             
     Settings.batterySetting = !Settings.batterySetting;                                                                
     item.setSubLabel(Settings.batterySetting ? Rez.Strings.on : Rez.Strings.off);                                     
     Application.Properties.setValue("batterySetting", Settings.batterySetting);                                        
     Settings.getProperties();
     }   

    hidden function toggleBasePic(item){                                                                             
     Settings.basePicFireSetting = !Settings.basePicFireSetting;                                                                
     item.setSubLabel(Settings.basePicFireSetting ? Rez.Strings.on : Rez.Strings.off);                                     
     Application.Properties.setValue("basePicFireSetting", Settings.basePicFireSetting);                                        
     Settings.getProperties();
     }   
}
