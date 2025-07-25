# Garmin Watch Face: [Fine'o clock](https://apps.garmin.com/en-US/apps/46e9c768-4eb1-470c-93a8-29dd11219b61) 


<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/7c6ec408-9f7b-4fbd-93ba-6ed820a9935c" width="200"/></td>
    <td><em>This is Fine</em> meme. Time, date, battery life, heart rate, and stress level are the default settings. 
        The illustration gets animated once your stress levels reach above 50%.</td>
  </tr>
</table>



---
<img width="900" src="https://github.com/user-attachments/assets/4c6d838c-bd2c-4c7b-a37c-6baecd75a26f" />
<img width="900"  src="https://github.com/user-attachments/assets/d11aaef0-247f-4927-a48d-0a51b1af9f57" />

<img width="900"src="https://github.com/user-attachments/assets/89c1f9be-5e9a-43ac-adb2-2df077df9178" />


https://github.com/user-attachments/assets/80156576-78e5-411a-927e-0950d5551592


---
### Settings

---

There are four fields you can change the settings for:

|               | Smoke | Bubble | Cup | Body |
|------------------------|-----|------|---|-----------------|
| This is fine           | ✓    | ✓     |     |                   |
| Date                   | ✓    | ✓     |     |                   |
| Time                   | ✓    | ✓     |     |                   |
| Active Minutes         | ✓    | ✓     |     |                   |
| Steps               | ✓    | ✓     |     |                   |
| Calories               | ✓    | ✓     |     |                   |
| Stress Levels          | ✓    | ✓     | ✓  |                   |
| Body Battery           | ✓    | ✓     | ✓  |                   |
| % Calorie Goal         | ✓    | ✓     | ✓  |                   |
| % Steps Goal         | ✓    | ✓     | ✓  |                   |
| Heart Rate             | ✓    | ✓     |✓   | ✓               |
| None                   | ✓    | ✓     | ✓  | ✓                |

You can also:
* turn the animation off
* set the threshold for the stress level animation
* set your calorie goal



## Set-up
### Installations

- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/reference-guides/monkey-c-command-line-setup/) - follow the steps in the link for your operating system
- *VS Code* or *Curser* with the *Monkey C Extension*
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
* Trigger App Settings & click on the buttons in the simulator
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
