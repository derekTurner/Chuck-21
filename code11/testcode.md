# Testcode

Details on code with syntax highlight.

```c
    // setup and play 16 samples with control from controllers 21 - 28
 
    ["Tabla 01","Tabla 02","Tabla 03","Tabla 04","Tabla 05","Tabla 06",
     "Tabla 07","Tabla 08","Tabla 09","Tabla 10","Tabla 11","Tabla 12",
     "Tabla 13","Tabla 14","Tabla 15","Tabla 16"] @=>string fileNames [];

    Gain percGain => outlet;
    0.8 => percGain.gain;

    SndBuf buffers[16];
    int    sampleLengths[16];
```