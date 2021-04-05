
ColorPicker.new
(
s.freeAll;
s.newBusAllocators;
s.newBufferAllocators;
Window.closeAll;
s.reboot;

s.waitForBoot({


	b = Buffer.read(s, "water.wav".resolveRelative);
		MIDIClient.init;

	MIDIIn.connectAll;


	~windowColors = (
		0:Color.red,
		1:Color(0.71, 0.14, 0.29),
		2:Color(0.93, 0.43),
		3:Color.yellow,
		4:Color.green,
		5:Color.blue,
		6:Color(0.63, 0, 1),
		7:Color.black
	);


	~numberTracks = 8;


	~gui = Window("Sounds", Window.availableBounds, false);

	~trackViews = {|i| CompositeView(~gui, Rect(
		i*(Window.availableBounds.width/~numberTracks),
		0,
		Window.availableBounds.width/~numberTracks,
		Window.availableBounds.height)
	).background_(~windowColors[i])}!8;

	~trackNumbers = {|i| StaticText(~trackViews[i], Rect(
		((Window.availableBounds.width/~numberTracks)/2)-20,
		Window.availableBounds.height*0.9,
		Window.availableBounds.width/~numberTracks,
		30))
	.string_((i+1).asString)
	.font_(Font("Arial", 40 ,true))}!8;


	~trackSounds = {|i| StaticText(~trackViews[i], Rect(
		0,
		Window.availableBounds.height*0.65,
		Window.availableBounds.width/~numberTracks,
		Window.availableBounds.height*0.3))
	.font_(Font("Constantia", 20))}!8;


	~trackVolumeSlider = {|i| Slider(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0,
		Window.availableBounds.height*0.57,
		(Window.availableBounds.width/~numberTracks)*0.7,
		Window.availableBounds.height*0.05))
	.orientation_(\horizontal)

	}!8;

	~trackVolumeSliderVal = {|i| TextField(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.7,
		Window.availableBounds.height*0.57,
		(Window.availableBounds.width/~numberTracks)*0.3,
		Window.availableBounds.height*0.05))
	.string_("0")
	.font_(Font("Constantia", 20))

	}!8;





	~trackRateKnob = {|i| Knob(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0,
		Window.availableBounds.height*0.5,
		(Window.availableBounds.width/~numberTracks)*0.5,
		Window.availableBounds.height*0.05))
	.value_(0.5)

	}!8;

	~trackRateKnobVal = {|i| TextField(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.5,
		Window.availableBounds.height*0.5,
		(Window.availableBounds.width/~numberTracks)*0.5,
		Window.availableBounds.height*0.05))
	.string_("1")
	.font_(Font("Constantia", 20))

	}!8;

	~gui.front;


~colors = [410, 460, 490, 515, 545, 666, 710, 790];
	~powers2= Array.geom(6, 0.5, 2);

(
SynthDef(\colors,
	{
		|freq=400, amp=0, rq=0.001, gate=1|
		var  sig, env;
				env= EnvGen.kr(Env.asr,gate);
				sig = PlayBuf.ar(2,b,1, loop:1)*(rq.expexp(0.001, 1, 4.0, 0.06));
		sig  = Resonz.ar(sig, freq, rq);
				sig = Splay.ar(sig, 1, amp.lag2(0.3));
				sig = Limiter.ar(sig, 0.9);
				Out.ar(0, sig * env);
	}
).add;
);

	~synths = {|i| Synth(\colors, [\freq, ~colors[i]*(~powers2.choose)])}!8;
	//~synths.collect({|i| i.set(\gate, 0)})



MIDIdef.cc(\nano, {
		arg val,num,chan,src;
		[val,num,chan,src];
		case(
			//CONTROLS FOR INDIVIDUAL TRACKS

			},

			//TRACK FADERS: VOLUME
			{num<8},{
			~synths[num%8].set(\amp, val.linlin(0,127,0,1.5));

				{~trackVolumeSlider[num%8].value_(val.linlin(0,127,0,1))}.defer;
		{~trackVolumeSliderVal[num%8].value_(val.linlin(0,127,0,1).round(0.001))}.defer;
			},

			//TRACK KNOBS: PITCH TO NOISE RATIO
			{(num>=16) && (num<=23)},{
			~synths[num%8].set(\rq, val.lincurve(0, 127, 0.001, 1, 6));

				{~trackRateKnob[num%8].value_(val.linlin(0,127,0,1))}.defer;
		{~trackRateKnobVal[num%8].value_(val.linlin(0,127,0,1).round(0.001))}.defer;
			}
)
});
})
)

b.numChannels