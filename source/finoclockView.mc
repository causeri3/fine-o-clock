import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Lang;



class finoclockView extends WatchUi.WatchFace {
    private var drawings as Drawings;
    var imageIndex = 0;
    var timer;
    var isAnimating = false;
    var timerTriggered = false;
    var sleep = false;
    var currentImage;


    function initialize() {
        WatchFace.initialize();
        drawings = new Drawings();
        setAnimationTimer();
    }


    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.WatchFace(dc));
    }


    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        Log.debug("In onShow");
        sleep = false;
        updateAnimationState();
    }

    function update_drawings(dc as Dc)as Void{
        drawBackground(dc);
        drawings.init(dc);
        drawings.drawBubble(dc);
        drawings.drawClouds(dc);
        drawings.drawHeart(dc);
        drawings.drawCup(dc);
        drawings.drawBattery(dc);
    }

    function onUpdate(dc as Dc) as Void {
        if(timerTriggered && isAnimating){
            update_drawings(dc);
            Log.debug("timerTriggered Update");
            timerTriggered = false;
        }
        else if((!timerTriggered && !isAnimating) || sleep){
            update_drawings(dc);
            Log.debug("Regular Update");
        }
        else{
            Log.debug("DONT UPDATE");
        }

        if (!sleep){
            updateAnimationState();
        }



    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        stopAnimation();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        // not sure if needed
        sleep = false;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        sleep = true;
        stopAnimation();
    }

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
        Log.debug("In setAnimationTimer: " + timer);
    }

    function random(min, max) {
        return min + Math.rand() % (max-min);   
    } 

    function restartAnimationTimer() {
    Log.debug("restartAnimationTimer() is being called.");

    if (timer != null) {
        timer.stop();
        // random intervall felt more organic to me
        var random_intervall = random(400, 600);
        Log.debug("New random_intervall: " + random_intervall);
        timer.start(method(:switchBackground), random_intervall, false); 
        }
    }

    function updateAnimationState() {
        var stressLevel = getStressLevel();
        // == doesnt work with strings in Monkey c - Java like
        stressLevel = stressLevel.equals("") ? 0 as Number : stressLevel.toNumber();

        if (stressLevel < 50) {
            stopAnimation();
            // free the previous image to save memory
            currentImage = null;
            currentImage = Application.loadResource(Rez.Drawables.stillPic) as BitmapResource;
        } else {
            startAnimation();
        }

    }

    function startAnimation() {
        if (timer != null && !isAnimating) {
            isAnimating = true;
            restartAnimationTimer();        
            }
    }

    function stopAnimation() {
        if (timer != null && isAnimating) {
            isAnimating = false;
            timer.stop();
            timerTriggered = false;
        }
    }

    function switchBackground() {
        // free the previous image to save memory
        currentImage = null;
        imageIndex = (imageIndex + 1) % 4;
        currentImage = loadImage(imageIndex);
        restartAnimationTimer();
        timerTriggered = true;
        requestUpdate();

    }

}



// todo
// clock in layout file?
// settings?