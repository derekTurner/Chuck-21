
# slider

This is a test of the communication flow of open sound control messages from an HTML page containing sliders and chuck.

## bridge.exe

This needs the bridge code in the bridge folder to be used as a bridge to recieve socket port messages from HTML and output these as OSC messages which chuck can recieve and interpret.

The bridge software can be used in a number of ways.  There are executable files provided for both Windows and OsX which may be run in stand alone mode.  There is also a python file which may be run from visual studio code provided that the appropriate python version and libraries have been installed to the local machine.

For the purpose of these notes I am using the windows exe version.  When this is run a terminal window opens with an inital message of Namespace(websocket=9998 osc=9999).

## sliderTemplate.html and osc_dump.ck

Load sliderTemplate.html into visual studio code.  This is a web page with sliders.  When these sliders are moved their values are output via a websocket to the bridge.  The bridge will display incoming messages.

HTML pages can be opened into a browser such as Microsoft edge just by double clicking in the windows explorer and this will work fine.

Alternatively, in order to see and edit the code the slider.html file can be opened in the visual studio code editor.  Provided the Live Server plugin by Ritwick Dey has been installed into visual studio code, the web page can be started by right clicking over the code and choosing "open with live server" from the drop down menu.  This serves the page to a browser from a testing server.  For the purpose of this module it does not matter which way you work, however during site development it is normally prefered to use a testing server as some javascript code requires this.

Run osc_dump.ck this will print the osc messages to the terminal matching the output from the bridge and showing the message address, typetag and values.

# ADSR

When the alphanumeric keyboard is used to play notes this causes clicks because the notes are switched on and off abruptly.  To avoid this and produce a controlled amplitude envelope the sound can be passed through an ADSR unit which gates the sound with controlled attack, decay, sustain and release.

When the ADSR envelope is triggered the sound will rise to its maximum level in the attack time.  The sound will then decay over the decay time until it reaches the sustain level whereupon the level is held constant until the envelope is cleared and the sound decays to zero level over the release time.  Note that the attack, decay and release are times, but sustain is a level.

The aim here is to add an ADSR unit to a simple sine oscillator to demonstrate the effect.  Then the sliders will be configured to give real time control of the ADSR parameters.  This will display a general approach which will be used to control parameters for more complex synthesised sounds.

# keyorganMap.ck Sound.ck SoundSinEnv.ck

KeyorganMap is unchanged from the version in the keyorgan folder.  This just triggers notes in response to the alphanumeric keyboard.

Sound.ck is the active sound and this is saved for later use in SoundSinEnv.ck.  When the sound is triggered an ADSR envelope is triggered instead of turning the gain abruptly up.  The ADSR envelope has parameter values added to the code which will make the envelope clearly audiable.  These values can be changed to hear their effects.

# Control

The aim now is to provide a standard interface to allow the html sliders to control the sound parameters.  As a first example the ADSR parameters will be controlled by the sliders.  This will need routing of the control signal flowing in from the individual sliders to the appropriate sound parameter.  The values sent by  the sliders are set to range from 0 - 127.  These values will need to be mapped onto a range of parameter values which will be useful for audio.  For instance an attack time of 127 would be way too large and 0 would produce clicks, so 0 - 127 needs to be mapped to a range typicaly 0.01 - 1.  The exact choice of mapping is up to the programmer.

# keyorganMapSpork.ck Sound.ck OscMonitor.ck SoundSinEnvParam.ck

KeyorganMapSpork.ck is triggering notes in response to the alphanumeric keyboard.  The oscMonitor.ck is monitoring the osc messages coming in and mapping these to parameter setting functions in Sound.ck.  The object is to confine the code which needs to be edited to the Sound.ck file, the other files provide library functions which do not need to be altered.

Run bridge.exe (or equivalent) and sliderTemplate.html then open all these files in a single command "chuck Sound.ck OscMonitor.ck keyorganMapSpork.ck"

The keyboard plays notes, the ADSR of the sound can be controlled by sliders and the effect auditioned.

This now provides a convenient way of investigating sound patches with parameters. The code in sound.ck can be edited to try out different patches.  Take care to copy the final patch into a second file to be caled back later.  In this case I have saved the working patch form Sound.ck to SoundSinEnvParam.ck.

* Take care on closing!  When you close the programme press control - pause till message All done appers - and then control +c.
  
# odeADSR

Once the sound has been refined and control parameters set it can be used to play a piece of programmed music with the slider control still in place.

To show this we will go back to 