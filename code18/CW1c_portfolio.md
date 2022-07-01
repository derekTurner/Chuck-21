# Audio Programming Coursework
## CW1c Customising a polyphonic keyboard with hardware slider control.

A chuck patch which acts as a polyphonic midi instrument and responds to control input from a control keyboard, push device or other software midi source. (40%) 

This portfolio file requires the customisation of files provided to replace the demo sound and samples and carry through the changes needed in the control code to match the new sounds.

The third portfolio file should be in a folder named B00xxxxxx_CWc. You should not include GUI files in the submission, I will run a master copy when I mark. The marking criteria will be based on the synthesis code, the control functions and the documentation according to the following guidelines which will be weighted to 40%
 
The coursework can be completed by working only in these two classes, the rest of the template can be regarded as library code and should not normally be edited.

To complete this assignment, you are asked to replace sounds used for the polyphonic voices with your own sounds and then to alter the control functions to match the requirements of your sound map.  This should only require changes in two files.

You will be assessed in this in terms of the detail of the synthesis and the appropriateness of the slider controls.

You should also replace the sample files with your own more interesting samples. Add a single sound effect after the sample (reverb, delay, filter, compression etc.) and apply control to this from dials.

This will be assessed on the application of effect and control.
Documentation for this exercise should include line numbered, syntax highlighted code extracts, but needs only to consider the classes where code changes are made.

All files for the complete portfolio, including samples, required to run the programme and documentation in markdown format should be included in a single zip archive.

The marks will contribute 40% of the module marks.
* Synthesised and sampled sound patches (10%)
* Code for sound control (10%)
* Documentation (10%)
* Audio Demo (10%)


### Marking Scheme

The marking scheme has been adapted from the handbook for the purposes of the resit submission as follows:

| Synthesised and sampled sounds (10%).         |   Detail of patch and replaced samples  |
| -- |----- |
| A3 Excellent, A2 Outstanding, A1 Exceptional |Excellent:  Well organised synthesis reflecting reading outside the module core or originally produced sample set. |
| B1  | Very Good:  As B2 with effective synthesis which changes tone through sustained note and evident standard effects such as reverb added to samples.  |
| B2    | Good: As C with synthesis based on a standard method: additive, subtractive, modulation.    |
| C   |  Satisfactory:  16 Sampled sounds replaced with a coherent set (not user generated). Simple sound patch.   |
| D    |  Weak: Patch does not produce audio output  

| Midi control of synthesis parameters (10%).  |    Sounds and samples |
| -- |----- |
| A3 Excellent, A2 Outstanding, A1 Exceptional |Excellent: Midi (or OSC) code allows full control of many patch parameters and with musical effect. |
| B1  | Very Good: Both synthesised or sampled sounds patches respond to Midi (or OSC) commands control values are well scaled for musical effect.  |
| B2    | Good: Both synthesised or sampled sounds patches respond to Midi (or OSC) commands. |
| C   |  Satisfactory: Either synthesised or sampled sounds patches respond to Midi (or OSC) commands.
| D    |  Weak: Code does not accurately respond to Midi (or OSC) commands    |


| Documentation (10%).  |    Mark down description of patch operation |
| -- |----- |
| A3 Excellent, A2 Outstanding, A1 Exceptional |Excellent:  Well-structured report with highlighted listing of key sections and a clear description of moderately complex sketch customisation reflecting a degree of originality.         |
| B1  | Very Good:  Well-structured report with highlighted listing of key sections and a clear description of moderately complex sketch customisation.      |
| B2    | Good: Well-structured report with highlighted listing of key sections and a clear description of sketch customisation.    |
| C   |  Satisfactory: Structured report with highlighted listing of key sections and adequate description of sketch.   |
| D    |  Weak: Listing of programme with inadequate formatting or description.                          |

| Creation of an audio demo file (10%).         | Demonstrating the usefulness of the patch|
| -- |----- |
| A3 Excellent, A2 Outstanding, A1 Exceptional |Excellent:  An aesthetic piece of polyphonic music (typically generated by a DAW) using the patch is recorded using both synthesis and sample playback demonstrating the effect of control settings.   |
| B1  | Very Good:  Polyphonic Audio from the patch is recorded using both synthesis and sample playback demonstrating the effect of control settings.  |
| B2    | Good: Polyphonic Audio from the patch is recorded using both synthesis and sample playback. |
| C   |  Satisfactory:  Polyphonic Audio from the patch is recorded.   |
| D    |  Weak:  Audio is generated represent the patch well.    |       |

Note that this portfolio piece is 40% of the module marks. You are expected to use example code from the module as a starter to develop from.