(
SynthDef(\dubstep, { arg note = 22,dur=2, pan=0, cutfreq = 1500;
	var trig, son, out, freq;

	freq = note.midicps;

	trig = CoinGate.kr(0.5, Impulse.kr(2));

	son = Mix.ar(LFSaw.ar(freq * [0.99, 1, 1.01]));
    son = LPF.ar(son, cutfreq);
    out = son + BPF.ar(son, cutfreq+500, 2);

	a = EnvGen.ar(Env.perc(0.01,1),doneAction:2);

	Out.ar(0, Pan2.ar(out*a*0.2,pan));
}).add;
)

(
SynthDef(\risset, { arg out= 0, pan= 0, note= 44, amp= 1, dur= 2, t_trig=1;
	var amps= [1, 0.67, 1, 1.8, 2.67, 1.67, 1.46, 1.33, 1.33, 1, 1.33];
	var durs = [1, 0.9, 0.65, 0.55, 0.325, 0.35, 0.25, 0.2, 0.15, 0.1, 0.075];
	var frqs = [0.56, 0.56, 0.92, 0.92, 1.19, 1.7, 2, 2.74, 3, 3.76, 4.07];
	var dets = [0, 1, 0, 1.7, 0, 0, 0, 0, 0, 0, 0];    // Detune
	var src,freq;

	freq = note.midicps;

	src = Mix.fill(11, {|i|
		var env= EnvGen.ar(Env.perc(0.005, dur*durs[i], amps[i], -4.5),t_trig);
		SinOsc.ar(freq*frqs[i]+dets[i], 0, amp*env);
	});
	Out.ar(out, Pan2.ar(src, pan));
}).add;
)


(
SynthDef(\drums, {|out = 0, bassLevel = 0 , snareLevel = 0, hatLevel = 0, tomLevel = 0, pan1 = 0, pan2 = 0, pan3 = 0, pan4 = 0|

 var env1, env2, env3, env4, bass, snare, hat, tom, bassOut, snareOut, hatOut, tomOut, mixer;
 env1 = EnvGen.kr(Env.perc(0.001, 0.2, 1, -4), 1, doneAction:2);
 env2 = EnvGen.kr(Env.perc(0.001, 0.5, 1, -1), 1, doneAction:2);
 env3 = EnvGen.kr(Env.perc(0.002, 0.3, 1, -2), 1, doneAction:2);
 env4 = EnvGen.kr(Env.perc(0.001, 0.1, 1, -5), 1, doneAction:2);


bass = SinOsc.ar(80) + Crackle.ar(1, 0.5);
 bassOut = Pan2.ar(bass*env1*2, pan1, bassLevel);

 snare = SinOsc.ar(120) - WhiteNoise.ar(0.5, 0.5);
 snareOut = Pan2.ar(snare*env4, pan2, snareLevel);

 hat = Klank.ar(`[ [ 6563, 9875 ],
  [ 0.6, 0.5 ],
  [ 0.002, 0.003] ], PinkNoise.ar(1));
 hatOut = Pan2.ar(hat*env3, pan2, hatLevel);

 tom = SinOsc.ar(440);
 tomOut = Pan2.ar(tom*env4, pan4, tomLevel);

 mixer = Mix.new([bassOut, snareOut, hatOut, tomOut]);


 Out.ar(out, mixer);

 }).add
)


(
SynthDef(\PMCrotale, {
arg midi = 60, tone = 3, art = 1, amp = 0.8, pan = 0;
var env, out, mod, freq;

freq = midi.midicps;
env = Env.perc(0, art);
mod = 15 + (1/IRand(2, 6));

out = PMOsc.ar(freq, mod*freq,
	pmindex: EnvGen.kr(env, timeScale: art, levelScale: tone),
	mul: EnvGen.kr(env, timeScale: art, levelScale: 0.3));

out = Pan2.ar(out, pan);
Out.ar(0, out);

}).add;
)



(
~bass_cutoff = 1500;

TempoClock.default.tempo = 132/60;

// BASS
p = Pxrand([
    Pbind(
        \instrument, \dubstep,
        \note, Pseq([36, 42, 41, 33], 1),
        //\dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1)
		\dur, Pseq([1, 1, 1, 1], 1),
		\cutfreq, Pfunc{~bass_cutoff}
    )
], inf).play(quant: 1);

// BELL
p = Pxrand([
    Pbind(
        \instrument, \risset,
        \note, 60,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1)
    ),
    Pmono(\risset,
        \note, Pseq([60, 72, 60], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1)
    ),
    Pmono(\risset,
        \note, Pseq([60, 66, 65, 68], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1)
    ),
    Pmono(\risset,
        \note, Pseq([60, 63, 60, 68], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1)
    )
], inf).play(quant: 1);


// CROTALE
p = Pxrand([
    Pbind(
        \instrument, \PMCrotale,
        \note, 60,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1)
    ),
    Pmono(\PMCrotale,
        \note, Pseq([60, 72, 60], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1)
    ),
    Pmono(\PMCrotale,
        \note, Pseq([60, 66, 65, 68], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1)
    ),
    Pmono(\PMCrotale,
        \note, Pseq([60, 63, 60, 68], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1)
    )
], inf).play(quant: 1);


// DRUM
 a = Pseq ([1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]);
 b = Pseq ([0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0]);
 c = Pseq ([0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0]);
 d = Pseq ([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);


 p = Pbind(
  \instrument, \drums,
  \dur, 0.12,
  \bassLevel, Pseq ([a], inf),
  \snareLevel, Pseq ([b], inf),
  \hatLevel, Pseq ([c], inf),
  \tomLevel, Pseq ([d], inf)

  ).play;

)

(
// SuperCollider will listent to msgs at defined port and address
NetAddr("10.79.9.201",57120);

// OSC Receivers
OSCdef('OSCreceiver',
	{
		arg msg;

		x = msg[1];

		x = (x-0.5)/0.5;

		~bass_cutoff = abs(x*1000);
		postln(~bass_cutoff);
	},
	"/gyrosc/mobile1/gyro");

/*
OSCdef('OSCreceiver',
	{
		arg msg;

		x = msg[1];
		y = msg[2];

		x = (x-0.5)/0.5;

		postln("x: "+x+" - y: "+y);
		synth1.set(\amp,y,\pan,x);
		synth2.set(\amp,1-y,\pan,1-x);

	},
	"/par_risset");


OSCdef('OSCreceiver',
	{
		arg msg;

		x = msg[1];
		y = msg[2];

		x = (x-0.5)/0.5;

		postln("x: "+x+" - y: "+y);
		synth1.set(\amp,y,\pan,x);
		synth2.set(\amp,1-y,\pan,1-x);

	},
	"/par_drums");

OSCdef('OSCreceiver',
	{
		arg msg;

		x = msg[1];
		y = msg[2];

		x = (x-0.5)/0.5;

		postln("x: "+x+" - y: "+y);
		synth1.set(\amp,y,\pan,x);
		synth2.set(\amp,1-y,\pan,1-x);

	},
	"/par_crotale");*/
)



