
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Lang;
import Toybox.System;


class BackgroundAnimation {
    private var imageIndex = 0;
    private var timer;
    private var currentImage;
    var isAnimating = false;

    function drawBackground(dc) {

        if (currentImage == null) {
            currentImage = loadImage(imageIndex);
        }
        dc.drawBitmap(0, 0, currentImage);
    }

    function loadImage(index) {
        if (index == 0) { return Application.loadResource(Rez.Drawables.firstMovePic) as BitmapResource; }
        if (index == 1) { return Application.loadResource(Rez.Drawables.seconMovePic) as BitmapResource; }
        if (index == 2) { return Application.loadResource(Rez.Drawables.thirdMovePic) as BitmapResource; }
        if (index == 3) { return Application.loadResource(Rez.Drawables.fourthMovePic) as BitmapResource; }
        return null;
    }

    function chooseBasePic() as BitmapResource {
        if (Settings.basePicFireSetting){
            return Application.loadResource(Rez.Drawables.stillPic) as BitmapResource;
            }
        else {
            return Application.loadResource(Rez.Drawables.stillPicNoFire) as BitmapResource;
            }
        }


    function setAnimationTimer() as Void {
       if (timer == null) {
           timer = new Timer.Timer();
       }
        //Log.debug("In setAnimationTimer: " + timer.toString());
    }

    function random(min, max) as Number {
        return min + Math.rand() % (max-min);   
    } 

    function restartAnimationTimer() {
        //Log.debug("restartAnimationTimer() is being called.");

        if (timer != null) {
            timer.stop();
            // random intervall felt more organic to me
            var random_intervall = random(400, 600);
            //Log.debug("New random_intervall: " + random_intervall);
            timer.start(method(:switchBackground), random_intervall, false); 
        } else {
            //Log.debug("Timer is null in restartAnimationTimer()");
        }
    }

    function updateAnimationState() as Void {
        var stressLevel = getStressLevel();
        // == doesnt work with strings in Monkey c - Java like
        stressLevel = stressLevel.equals("") ? 0 as Number : stressLevel.toNumber();

        if (stressLevel < Settings.stressScoreSetting) {
            stopAnimation();
            currentImage = null;
            currentImage = chooseBasePic();
        } else {
            startAnimation();
        }

    }

    function setStaticStressPicture() as Void {
        var stressLevel = getStressLevel();
        stressLevel = stressLevel.equals("") ? 0 as Number : stressLevel.toNumber();
        if (stressLevel > Settings.stressScoreSetting) {
            imageIndex = 1;
            currentImage = null;
            currentImage = loadImage(imageIndex);
            }
        else {
            currentImage = null;
            currentImage = chooseBasePic();
        }
    }

    function startAnimation() as Void {
        //Log.debug("in startAnimation: isAnimating is " + isAnimating.toString());

        if (timer != null && !isAnimating) {
            isAnimating = true;
            restartAnimationTimer();        
            }
    }

    function stopAnimation() as Void {
        //Log.debug("in stopAnimation: isAnimating is " + isAnimating.toString());
        //Log.debug("timer is null: " + (timer == null).toString());
        if (timer != null && isAnimating) {
            isAnimating = false;
            timer.stop();
        }
    }

    function switchBackground() as Void {
        imageIndex = (imageIndex + 1) % 4;
        // Log.debug("BEFORE NULLING");
        // Log.showMemoryUsage();
        // free the previous image to save memory
        currentImage = null;
        // Log.debug("AFTER NULLIG");
        // Log.showMemoryUsage();
        currentImage = loadImage(imageIndex);
        // Log.debug("AFTER LOADING");
        // Log.showMemoryUsage();
        restartAnimationTimer();
        WatchUi.requestUpdate(); 
    }
}

