# Garmin Watch Face: Fine'o clock 


With the *this is fine* meme. Time, date, battery life, heart rate and stress level are the default settings. The illustration gets animated once your stress levels reach above 50%.

---
### Settings

---

There are four fields you can change the settings for:

|               | Smoke | Bubble | Cup | Body of the Doggo |
|------------------------|-----|------|---|-----------------|
| This is fine           | ✓    | ✓     |     |                   |
| Date                   | ✓    | ✓     |     |                   |
| Time                   | ✓    | ✓     |     |                   |
| Calories               | ✓    | ✓     |     |                   |
| Stress Levels          | ✓    | ✓     | ✓  |                   |
| % Calorie Goal         | ✓    | ✓     | ✓  |                   |
| Body Battery           | ✓    | ✓     | ✓  |                   |
| Heart Rate             | ✓    | ✓     | ✓   | ✓               |
| None                   | ✓    | ✓     | ✓  | ✓                |

You can also:
* turn the animation off
* set the threshold for the stress level animation
* set your calorie goal



## Set-up
### Installations

- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/reference-guides/monkey-c-command-line-setup/) - follow the steps in the link for your operating system
- *VS Code* or *Curser* with the *Monkey C E✓tension*
- [Java Development Kit (JDK)](https://www.oracle.com/java/technologies/javase-downloads.html)



### Build & Run
---
* Set-up variables

    Fill in your set-up variables in `properties.mk`

* Build with debug logs
   ```sh
   make build
   ```
* Run on simulator
   ```sh
   make run.settings
   ```
* Build for device
   ```sh
   make build.release
   ```
* Deploy on device
    1. Enable *Developer Mode* on your Garmin watch. 
    2. Copy the compiled `.prg` file from the `bin` into the `/GARMIN/APPS/` directory on your watch. (For Mac I used [Android File Transfer](https://android.p2hp.com/filetransfer/index.html))


If you want to test the settings on your comupter you can go in the Simulator either
* Trigger App Settings & click on teh buttons in teh simulator
or
* File > Edit Persistent Storage > Edit Application.Properties data


---

Contributions are more than welcome, if you give me time to test them, I might release it and publish to Connect IQ.

---
#### Thanks

This beautifully build and structured repository helped me greatly to understand and build (apart from the watchface being stunning and highly customizable):
[garmin-watchface-protomolecule](https://github.com/blotspot/garmin-watchface-protomolecule)

---

#### License
This project is licensed under the **MIT License**.
