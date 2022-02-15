// an ADSR envelope
//
// Repeated notes woth a normal distribution around 440Hz
//
// chuck normdistFreq.ck
// (also see envelope.ck)
SinOsc s => ADSR e => dac;

// set a, d, s, and r
e.set( 10::ms, 8::ms, .5, 500::ms );
// set gain
.5 => s.gain;

// infinite time-loop
while( true )
{
    // choose freq
    normRand(20, 3, 440) => s.freq;

    // key on - start attack
    e.keyOn();
    // advance time by 800 ms
    500::ms => now;
    // key off - start release
    e.keyOff();
    // advance time by 800 ms
    800::ms => now;
}

function float normRand(int n, float sigma, float mean ){
    // n is number to average typical 20 minimum 3 gives looser fit to normal distribution
    // std deviation sigma 68.2% within 1 sigma 95.4 within 2 sigma 99.7 within 3 sigma
    // mean is average value of distribution.
    // Mohazzabi, P. and Connolly, M. (2019) An Algorithm for Generating Random Numbers with Normal Distribution. Journal of Applied Mathematics and Physics, 7, 2712-2722. doi: 10.4236/jamp.2019.711185.
  
    0.0 => float x;
    for (0 =>int index; index < n; index ++){
       Math.random2f( 0, 1 ) + x => x;
    }
    x/n => x;  // x is mean of n random generated numbers 0 - 1
    Math.sqrt(3 * n)* sigma * ((2 * x) -1) + mean => x;
    <<<x>>>;
    return x;
}
