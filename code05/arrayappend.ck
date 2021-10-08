// Append to an array which has an element
// chuck arrayappend.ck


["clap_01.wav"] @=> string samplefiles[];
samplefiles << "click_01.wav";
samplefiles << "click_02.wav";
samplefiles << "cowbell_01.wav";
samplefiles << "hihat_01.wav";

<<< samplefiles[0], samplefiles[1] , samplefiles[2], samplefiles[3], samplefiles[4]>>>;