# Slider Controlled Sound

In this section the sound patches are developed further, they are still not too complex, but have enough detail to be interesting and have aspects which could be controlled from outside chuck.

Ultimately chuck sound parameters can be controlled from external hardware, but at this intermediate stage sliders on an HTML page will be used to control them.

HTML browser pages programmed with JavaScript can connect to other programmes using web sockets.  Chuck is able to listen to open sound control messages (OSC).  A bridge programme is provided which recieves the browser messages into a websocket and forwards this on to chuck as OSC messages.

The bridge programme was written in the Processing language and exported to two stand alone versions, one for Mac and one for PC.

Once a control link is established a timed sequence could be played and the sound varied using sliders during the performance.

To allow the musical content of the sequence to be more interesting the audio tracks can be prepared in a music editor or DAW and converted to a format which chuck can easily read in.

At this stage we are not ready to deal with MIDI, so if MIDI is prepared in a DAW it must be exported and loaded into Muse Score.  If you are comfortable working with music score you can write music direcly in this Muse Score.  Either way, when the music is ready export it part by part to the most basic MusicXML format, this in turn is converted using an online application into ABC format and that is converted (using a chuck program written by myself) to a list of numbers in a file which I will call mdv (midi note, duration, volume) format.

This conversion process is a long pipeline and so care must be taken and you must also bear in mind that the ABC -> MDV conversion has limitations: you can get bad results by trying to make the music too complex.  The conversion needs monophonic parts, so no chords, no overlapping of notes, it does not expect to find lyrics, and it will not handle volta (first and second time bars) so write the music out in full.  Despite all of these limitations you should be able to create a more satisfying musical structure in this way than by translating music into code manually.

The aim is to produce an interesting multipart piece playing on sounds which can be controlled from HTML sliders and this will piece will be coursework 1b.
