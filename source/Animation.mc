
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Lang;
import Toybox.System;

class BackgroundAnimation {
    private var imageIndex = 0;
    private var timer;
    private var currentImage;
    var isAnimating = false;
    var timerTriggered = false;

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


    function setAnimationTimer() {
       if (timer == null) {
           timer = new Timer.Timer();
       }
        Log.debug("In setAnimationTimer: " + timer.toString());
    }

    function random(min, max) {
        return min + Math.rand() % (max-min);   
    } 

    function restartAnimationTimer() {
        Log.debug("restartAnimationTimer() is being called.");

        if (timer != null) {
            //Log.debug("Timer object: " + timer.toString());
            timer.stop();
            // random intervall felt more organic to me
            var random_intervall = random(400, 600);
            //Log.debug("New random_intervall: " + random_intervall);
            timer.start(method(:switchBackground), random_intervall, false); 
        } else {
            Log.debug("Timer is null in restartAnimationTimer()");
        }
    }

    function updateAnimationState() {
        var stressLevel = getStressLevel();
        // == doesnt work with strings in Monkey c - Java like
        stressLevel = stressLevel.equals("") ? 0 as Number : stressLevel.toNumber();

        if (stressLevel < Settings.stressScoreSetting) {
            stopAnimation();
            // free the previous image to save memory
            currentImage = null;
            currentImage = Application.loadResource(Rez.Drawables.stillPic) as BitmapResource;
        } else {
            startAnimation();
        }

    }

    function startAnimation() {
        Log.debug("in startAnimation: isAnimating is " + isAnimating.toString());

        if (timer != null && !isAnimating) {
            isAnimating = true;
            restartAnimationTimer();        
            }
    }

    function stopAnimation() {
        Log.debug("in stopAnimation: isAnimating is " + isAnimating.toString());
        Log.debug("timer is null: " + (timer == null).toString());
        if (timer != null && isAnimating) {
            isAnimating = false;
            timer.stop();
            timerTriggered = false;
        }
    }

    function switchBackground() as Void {
        // free the previous image to save memory
        currentImage = null;
        imageIndex = (imageIndex + 1) % 4;
        currentImage = loadImage(imageIndex);
        restartAnimationTimer();
        timerTriggered = true;
        WatchUi.requestUpdate(); 
    }
}

