
# odes

Files in the odes folder working with tune of Ode to Joy towards playing tune and harmony on different sounds loaded from separate files.

## odearray.ck

Refactoring to play tune from midi notes, tick durations and velocities

## odefunction.ck

Refactoring to move player code into a fuction.

## odespork.ck

Refactoring to run player function in own thread

## odedemo1.ck

Develop the odespork.ck code to play tune and harmony on two sine wave oscillators

## odedemo2.ck

Develop the odedemo1.ck code to play tune on harmony on separate sound patches, simply a sine and a triangle oscillator.

## odesplayer1.ck and sound.ck soundSine.ck

Develop odeplayer.ck from odespork.ck to read sound in from a separate sound patch file a separate class file. 
Develop sound in sound.ck using chubgraph then save it for later use in this case into soundSine.
To restore any sound patch then simply copy the relevent SoundMysound.ck file into Sound.ck 
I will save files containing classes with filenames starting with a capital letter.

## odesplayer2.ck and Sound1.ck Sound2.ck

Adapt from odedemo 2 into odesplayer1.ck to make odesplayer2 play from two external sound files Sound1.ck and Sound2.ck
Note that the class names in these files need to match the file name so Sound1 and Sound 2 rather than just Sound.

# keyorgan

Make sounds in classes playable from a keyorgan for ease of auditioning during sound patch development

## keyorganAll.ck and Sound.ck 

Play the sound in Sound.ck from the alphanumeric keyboard using key numbers to produce midi notes

## keyorganMap.ck and Sound.ck 

Play the sound in Sound.ck from the alphanumeric keyboard using keboard mapping so that letters map to a piano keyboard pattern.

