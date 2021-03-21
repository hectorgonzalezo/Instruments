//make sure to download the Freesound Quark


(
s.freeAll;
s.newBusAllocators;
s.newBufferAllocators;
Window.closeAll;
s.reboot;

s.waitForBoot({
	MIDIClient.init;
	MIDIIn.connectAll;



	Freesound.authType = "token"; // default, only needed if you changed it
	Freesound.token= ""//add your own token here
	//instructions on how to get your own token can be found here:
	//https://freesound.org/docs/api/authentication.html

	//directory where sounds will be downloaded to
	~path = "buffers/".resolveRelative;


	//create directory if it doesn't exist
	File.mkdir(~path);

	~numberResults = {(0..10).wchoose(
		(2,1.8..0).collect({|i| i.linexp(0,2,1,7)}).normalizeSum)};



		////////////////////////////////////////////////////////////////////////
	//////
	///////////////////////GUI//////////////////////////////////
	//////
	///////////////////////////////////////////////////////////////////////

	~numberTracks = 8;


	~gui = Window("Sounds", Window.availableBounds, false);

	~trackViews = {|i| CompositeView(~gui, Rect(
		i*(Window.availableBounds.width/~numberTracks),
		0,
		Window.availableBounds.width/~numberTracks,
		Window.availableBounds.height)
	).background_(Color.rand)}!8;

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





	~trackPitchShift = {|i| Button(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.1,
		Window.availableBounds.height*0.44,
		(Window.availableBounds.width/~numberTracks)*0.8,
		Window.availableBounds.height*0.05))

	}!8;

	~trackPitchShift.collect({|button| button.states = [
		["Pitch Shift On", Color.black, Color.red],
		["Pitch Shift Off", Color.black, Color.white]
		]});




		~trackModulation = {|i| Button(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.1,
		Window.availableBounds.height*0.37,
		(Window.availableBounds.width/~numberTracks)*0.8,
		Window.availableBounds.height*0.05))

	}!8;

	~trackModulation.collect({|button| button.states = [
		["Modulation Off", Color.black, Color.white],
		["Modulation On", Color.black, Color.red]
		]});


			~trackDelay = {|i| Button(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.1,
		Window.availableBounds.height*0.3,
		(Window.availableBounds.width/~numberTracks)*0.8,
		Window.availableBounds.height*0.05))

	}!8;

	~trackDelay.collect({|button| button.states = [
		["Delay Off", Color.black, Color.white],
		["Delay On", Color.black, Color.red]
		]});



		~trackDistortion = {|i| Button(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.1,
		Window.availableBounds.height*0.2,
		(Window.availableBounds.width/~numberTracks)*0.8,
		Window.availableBounds.height*0.05))

	}!8;

	~trackDistortion.collect({|button| button.states = [
		["Distortion Off", Color.black, Color.white],
		["Distortion On", Color.black, Color.red]
		]});

	~trackDistortionAmount = {|i| StaticText(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.1,
		Window.availableBounds.height*0.25,
		(Window.availableBounds.width/~numberTracks)*0.8,
		Window.availableBounds.height*0.05))
	.string_("Distortion = 0")
	.font_(Font("Arial", 15 ,true))}!8;


	~trackFeedback = {|i| Button(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.1,
		Window.availableBounds.height*0.1,
		(Window.availableBounds.width/~numberTracks)*0.8,
		Window.availableBounds.height*0.05))

	}!8;

	~trackFeedback.collect({|button| button.states = [
		["Feedback Off", Color.black, Color.white],
		["Feedback On", Color.black, Color.red]
		]});

	~trackFeedbackAmount = {|i| StaticText(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.1,
		Window.availableBounds.height*0.15,
		(Window.availableBounds.width/~numberTracks)*0.8,
		Window.availableBounds.height*0.05))
	.string_("Feedback = 0")
	.font_(Font("Arial", 15 ,true))}!8;

	~trackGranulator = {|i| Button(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.1,
		Window.availableBounds.height*0,
		(Window.availableBounds.width/~numberTracks)*0.8,
		Window.availableBounds.height*0.05))

	}!8;

	~trackGranulator.collect({|button| button.states = [
		["Granulator Off", Color.black, Color.white],
		["Granulator On", Color.black, Color.red]
		]});


	~trackGrainDensity = {|i| StaticText(~trackViews[i], Rect(
		(Window.availableBounds.width/~numberTracks)*0.1,
		Window.availableBounds.height*0.05,
		(Window.availableBounds.width/~numberTracks)*0.8,
		Window.availableBounds.height*0.05))
	.string_("Grain Density = 0")
	.font_(Font("Arial", 15 ,true))}!8;






	~gui.front;






	////////////////////////////////////////////////////////////////////////
	//////
	///////////////////////MAIN FUNCTIONS///////////////////////////////////
	//////
	///////////////////////////////////////////////////////////////////////



	//main downloader function

	~trackFunc = {

		|track|

		FSSound.textSearch(
			query: ~tagVal.asString ,
			filter: "channels:2 type:wav OR aiff".asString,
			action:{|p|
				~snd[track] = p[
					~numberResults.value
				]; // choose result
				~snd[track].name.postln;


				// This block of code will download the preview

				~groups[track].set(\gate, 0);

				{~trackSounds[track].string_("Searching...");}.defer;


				~preview = ~snd[track].retrievePreview(~path.asString, {
					~buffers[track] = Buffer.read(
						s,
						~path.asString ++ ~snd[track].previewFilename,
						action:{

							~path.asString ++ ~snd[track].previewFilename.postln;

							~synths[track] = Synth(\sequencer, [
								\bufnum, ~buffers[track],
								\amp, ~amps[track],
								\rate, ~rates[track],
								\out, ~buses[track]
							],
							~groups[track]
							);


							~nodeProxys[track][0] = { In.ar(~buses[track],2)};
							~nodeProxys[track].play;
							("playback of track#"++(track+1) ++" started").postln;
							{~trackSounds[track].string_(~snd[track].previewFilename.splitext[0]);}.defer;

						}
					);
				});

			}
		);

	};

	~similarFunc = {

		|track|

		~snd[track].getSimilar(action:{|p| ~snd[track] = p[rrand(0,3)] });
		~groups[track].set(\gate,0);


		{~trackSounds[track].string_("Searching...");}.defer;


		~preview = ~snd[track].retrievePreview(~path.asString, {

			~buffers[track].free;

			~buffers[track] = Buffer.read(
				s,
				~path.asString ++ ~snd[track].previewFilename,
				action: {
					|buffer|
					~path.asString ++ ~snd[track].previewFilename.postln;

					~synths[track] = Synth(\sequencer, [
						\gate, 1,
						\bufnum, buffer,
						\amp, ~amps[track],
						\rate, ~rates[track],
						\out, ~buses[track]
					],
					~groups[track]
					);


					~nodeProxys[track][0] = {In.ar(~buses[track],2)};
					~nodeProxys[track].play;

					("playback of track#"++(track+1) ++" started").postln;
					{~trackSounds[track].string_(~snd[track].previewFilename.splitext[0]);}.defer;
				}


			);
		});

	};




	~shifterFunc = {
		|track|

		if(~shiftBool[track] == false,
			{
				~synths[track].set(\shifter, 0);
				~shiftBool[track] = true;
				"pitch shift off".postln;

				{~trackPitchShift[track].value = 1}.defer;
			},
			{
				~synths[track].set(\shifter, 1);
				~shiftBool[track] = false;
				"pitch shift on".postln;

				{~trackPitchShift[track].value = 0}.defer;
			}
		)

	};

	~ampFunc = {
		|track, val|
		~synths[track].set(\amp, val.linlin(0,127,0,1));
		~amps[track] = val.linlin(0,127,0,1);
		~amps[track].postln;

		{~trackVolumeSlider[track].value_(val.linlin(0,127,0.001,1))}.defer;
		{~trackVolumeSliderVal[track].value_(val.linlin(0,127,0.001,1).round(0.001))}.defer;


	};



	~rateFunc = {
		|track, val|
		~synths[track].set(\rate, val.linlin(0,127,0.001,2));
		~rates[track] = val.linlin(0,127,0.001,2);
		~rates[track].postln;

		{~trackRateKnob[track].value_(val.linlin(0,127,0.001,1))}.defer;
		{~trackRateKnobVal[track].value_(val.linlin(0,127,0.001,2).round(0.001))}.defer;


	};




	//Prompt GUI creator
	~guiFunc = {
		|track|


		~guiPr = Window("prompt", Rect(500, 500, 255, 150));

		~text = TextField(~guiPr, Rect(25,5,200,50));

		~button = Button(~guiPr,Rect(25,75,200,50))
		.states_([
			["go", Color.black, Color.red],
			[]

		])
		.action_({
			arg but;
			if( but.value ==1,
				{
					~tagVal = ~text.value;
					~guiPr.close;
					~trackFunc.value(track);


				}
			)
		});

		~text.keyDownAction = {
			arg view, char, modifiers, unicode, keycode;
			if(keycode ==13,
				{
					~tagVal = ~text.value;
					~guiPr.close;
					~trackFunc.value(track);
			});
		};


		~guiPr.front;

	};





	////////////////////////////////////////////////////////////////////////
	//////
	///////////////////////SYNTHDEFS///////////////////////////////////
	//////
	///////////////////////////////////////////////////////////////////////





	SynthDef.new(\sequencer, {
		arg amp=1, out=0, rate=1, bufnum, gate=1, shifter=1;
		var sig, shift, fin, env;
		env = EnvGen.kr(Env.asr, gate, doneAction:2);
		sig = PlayBuf.ar(2, bufnum, rate, amp, loop:1);
		shift = Select.ar(
			[shifter],
			[sig,
				PitchShift.ar(sig,
					0.2,
					rate.reciprocal.abs
				);
		]);
		fin = Pan2.ar(shift * amp);
		Out.ar(out, fin * env);
	}).add;


	s.sync;



	////////////////////////////////////////////////////////////////////////
	//////
	///////////////////////ARRAYS OF GROUPS, BUSES, NODES AND BOOLEANS////////////////////////////////
	//////
	///////////////////////////////////////////////////////////////////////


	//making arrays of 8 elements for every track in the controller
	~snd = nil!8;

	~groups = {Group.new}!8;


	~buses = {Bus.audio(s, 2)}!8;

	~buffers = nil!8;

	~nodeProxys = (NodeProxy(s).fadeTime=2)!8;

	~synths = nil!8;

	~amps = 0.001!8;
	~rates = 1!8;

	~distVal = 0!8;
	~fbVal = 0!8;
	~densVal = 0!8;


	~shiftBool = false!8;
	~delayBool = false!8;
	~modBool = false!8;
	~greyBool = false!8;
	~distortBool = false!8;
	~reverbBool = false!8;
	~grainBool = false!8;





	////////////////////////////////////////////////////////////////////////
	//////
	///////////////////////MAIN PATCH///////////////////////////////////
	//////
	///////////////////////////////////////////////////////////////////////

	s.sync;
	MIDIdef.cc(\nano, {
		arg val,num,chan,src;
		[val,num,chan,src];
		case(
			//CONTROLS FOR INDIVIDUAL TRACKS


			//TRACK RECORD BUTTONS: SHOW GUI
			{(num>=64) && (num<=71)},{
				~currentTrack= num%8;
				if(val==127,{
					{~guiFunc.value(num%8)}.defer
				}
			)},

			//TRACK SOLO BUTTONS: LOOK FOR SOUND WITH SIMILAR TAGS
			{(num>=32) && (num<=39)},{
				~currentTrack= num%8;
				if(val==127,
					{
						~similarFunc.value(num%8);
					}
				)
			},


			//TRACK MUTE BUTTONS: DEACTIVATE PITCH SHIFTER
			{(num>=48) && (num<=55)},{
				~currentTrack= num%8;
				if(val==127,{
					~shifterFunc.value(num%8);
				})

			},

			//TRACK FADERS: VOLUME
			{num<8},{
				~currentTrack= num%8;
				~ampFunc.value(num%8, val);
			},

			//TRACK KNOBS: RATE (-2 TO 2)
			{(num>=16) && (num<=23)},{
				~currentTrack= num%8;
				~rateFunc.value(num%8, val);
			},











			//CONTROLS FOR LEFT SIDE BUTTONS




			//play button: modulation determined by amplitude
			{num==41},{


				if(val ==0,{
					if(
						~modBool[~currentTrack] == false,{
							~nodeProxys[~currentTrack][40] = \filter -> {
								arg in; in * SinOsc.kr(Amplitude.kr(in).exprange(0.1,500)).range(0,1)
							};
							~nodeProxys[~currentTrack].set(\wet40, 1);
							"amp follower on".postln;
							~modBool[~currentTrack]= true;

							{~trackModulation[~currentTrack].value = 1}.defer;
						},
						{
							Task({
								(1,0.99..0).do({|i|
									~nodeProxys[~currentTrack].set(\wet40, i);
									0.02.wait;
								});
							}).play;

							~modBool[~currentTrack]= false;
							"amp follower off".postln;

							{~trackModulation[~currentTrack].value = 0}.defer;
						}
					)
				}
				)

			},



			//record button: delay effect
			{num==45},{
				if(val ==0,{
					if(
						~delayBool[~currentTrack] == false,{
							~nodeProxys[~currentTrack][50] = \filter -> {
								arg in; CombC.ar(in,0.2,{rrand(0.001,0.2)}, {rrand(1.0,6.0)})};
							~nodeProxys[~currentTrack].set(\wet50, 1);
							"delay on".postln;
							~delayBool[~currentTrack]= true;


							{~trackDelay[~currentTrack].value = 1}.defer;
						},
						{
							Task({
								(1,0.99..0).do({|i|
									~nodeProxys[~currentTrack].set(\wet50, i);
									0.02.wait;
								});
							}).play;

							~delayBool[~currentTrack]= false;
							"delay off".postln;

							{~trackDelay[~currentTrack].value = 0}.defer;
						}
					)
				}
				)

			},





			//marker "set" button: distortion
			{num==60},{
				if(val ==0,{
					if(
						~distortBool[~currentTrack] == false,{


							~shaperBuf = Buffer.alloc(s, 512, 1, { |buf| buf.chebyMsg(Array.fill(rrand(5,12),{rrand(0.15, 1.0)}))});

							if(~distVal[~currentTrack]==0,{

								~distVal[~currentTrack] = 10000});

							~nodeProxys[~currentTrack][20] = \filter -> {
								arg in, cutFreq=10000, dist=30, distAmp=0.5, vol=1;
								Limiter.ar(LPF.ar(Shaper.ar(~shaperBuf,(in*distAmp).abs)*distAmp.reciprocal,cutFreq);,0.99)};

							~nodeProxys[~currentTrack].set(\wet20, 1);
							"distortion on".postln;


							{~trackDistortion[~currentTrack].value = 1}.defer;

							{~trackDistortionAmount[~currentTrack].string_("distortion =" ++ ~distVal[~currentTrack].round.asString)}.defer;

							~distortBool[~currentTrack]= true;
						},
						{
							Task({
								(1,0.99..0).do({|i|
									~nodeProxys[~currentTrack].set(\wet20, i);
									0.02.wait;
								});
							}).play;

							~distortBool[~currentTrack]= false;
							~distVal[~currentTrack] = 0;

							{~trackDistortion[~currentTrack].value = 0}.defer;

							"distortion off".postln;
							{~trackDistortionAmount[~currentTrack].string_("distortion = 0")}.defer;



						}
					)
				}
				)

			},


			//lower distortion
			{num==61},{
				if(val==127,
					{
						~distVal[~currentTrack] = ~distVal[~currentTrack] - (~distVal[~currentTrack]/5);
						~nodeProxys[~currentTrack].set(\cutFreq, ~distVal[~currentTrack]);
						("distortion=" ++ ~distVal[~currentTrack]).postln;


						{~trackDistortionAmount[~currentTrack].string_("distortion =" ++ ~distVal[~currentTrack].round.asString)}.defer;

					}
				)
			},

			//increase distortion
			{num==62},{
				if(val==127,
					{
						~distVal[~currentTrack] = ~distVal[~currentTrack] + (~distVal[~currentTrack]/5);
						if(~distVal[~currentTrack] >= (s.options.sampleRate/2),
							{"value too high".postln;
								{~trackDistortionAmount[~currentTrack].string_("Value too high!")}.defer;


							},
							{
						~nodeProxys[~currentTrack].set(\cutFreq, ~distVal[~currentTrack]);
						("distortion=" ++ ~distVal[~currentTrack]).postln;


								{~trackDistortionAmount[~currentTrack].string_("distortion =" ++ ~distVal[~currentTrack].round.asString)}.defer;
							}
						);

					}
				)
			},







			//cycle button: feedback
			{num==46},{
				if(val ==0,{
					if(
						~greyBool[~currentTrack] == false,{

							if(~fbVal[~currentTrack]==0,{
								~fbVal[~currentTrack] = 0.1;});

							~nodeProxys[~currentTrack][60] = \filter -> {
								arg in, fb=0.1; Greyhole.ar(in,0.2, {rrand(0.7,0.9)}, {rrand(1,1.5)}, 0.6, fb)
							};

							Task({
								(0,0.01..1).do({|i|
									~nodeProxys[~currentTrack].set(\wet60, i);
									0.02.wait;
								});
							}).play;

							"greyhole on".postln;
							~greyBool[~currentTrack]= true;


							{~trackFeedback[~currentTrack].value = 1}.defer;


							{~trackFeedbackAmount[~currentTrack].string_("Feedback =" ++~fbVal[~currentTrack].asString)}.defer;
						},
						{
							Task({
								(1,0.99..0).do({|i|
									~nodeProxys[~currentTrack].set(\wet60, i);
									0.02.wait;
								});
							}).play;

							~greyBool[~currentTrack]= false;
							~fbVal[~currentTrack] = 0;
							"greyhole off".postln;


							{~trackFeedback[~currentTrack].value = 0}.defer;

							{~trackFeedbackAmount[~currentTrack].string_("Feedback = 0")}.defer;
						}
					)
				}
				)


			},


			//lower feedback
			{num==58},{
				if(val==127,
					{
						~fbVal[~currentTrack] = ~fbVal[~currentTrack] - 0.1;
						~nodeProxys[~currentTrack].set(\fb, ~fbVal[~currentTrack]);
						("Feedback=" ++ ~fbVal[~currentTrack]).postln;

						{~trackFeedbackAmount[~currentTrack].string_("Feedback =" ++~fbVal[~currentTrack].asString)}.defer;

					}
				)
			},

			//increase feedback
			{num==59},{
				if(val==127,
					{
						~fbVal[~currentTrack] = ~fbVal[~currentTrack] + 0.1;
						~nodeProxys[~currentTrack].set(\fb, ~fbVal[~currentTrack]);
						("Feedback=" ++ ~fbVal[~currentTrack]).postln;

						{~trackFeedbackAmount[~currentTrack].string_("Feedback =" ++~fbVal[~currentTrack].asString)}.defer;

					}
				)
			},






						//stop button: granulator
			{num==42},{

				if(val==127,
					{
						if(
						~grainBool[~currentTrack] == false,{

							if(~densVal[~currentTrack]==0,{
									~densVal[~currentTrack] = 50});

							~nodeProxys[~currentTrack][10] = \filter -> {
									arg in, dens=50; GrainIn.ar(2, Impulse.ar(dens.lag2(0.5)),(dens.lag2(0.5)).reciprocal,in)
							};

							Task({
								(0,0.01..1).do({|i|
									~nodeProxys[~currentTrack].set(\wet10, i);
									0.02.wait;
								});
							}).play;

							"granulator on".postln;
							~grainBool[~currentTrack]= true;


								{~trackGranulator[~currentTrack].value = 1}.defer;

								{~trackGrainDensity[~currentTrack].string_(~densVal[~currentTrack].asString)}.defer;

									{~trackGrainDensity[~currentTrack].string_("Grain density =" ++~densVal[~currentTrack].asString)}.defer;
						},
						{
							Task({
								(1,0.99..0).do({|i|
									~nodeProxys[~currentTrack].set(\wet10, i);
									0.02.wait;
								});
							}).play;

							~grainBool[~currentTrack]= false;
							~densVal[~currentTrack] = 0;
							"granulator off".postln;

								{~trackGranulator[~currentTrack].value = 0}.defer;


								{~trackGrainDensity[~currentTrack].string_(~densVal[~currentTrack].asString)}.defer;
								{~trackGrainDensity[~currentTrack].string_("Grain density = 0")}.defer;
						}
					)

					}
				)



			},



			//lower granulator density
			{num==43},{

				if(val==127,
					{
						~step= rrand(5,8);
						~densVal[~currentTrack] = ~densVal[~currentTrack] - (~densVal[~currentTrack]/~step).round;
						~nodeProxys[~currentTrack].set(\dens, ~densVal[~currentTrack]);
						("Grain density=" ++ ~densVal[~currentTrack]).postln;


						{~trackGrainDensity[~currentTrack].string_("Grain density =" ++~densVal[~currentTrack].asString)}.defer;

					}
				)

			},

			//increase granulator density
			{num==44},{
				if(val==127,
					{
						~step= rrand(5,8);
						~densVal[~currentTrack] = ~densVal[~currentTrack] + (~densVal[~currentTrack]/~step).round;
						~nodeProxys[~currentTrack].set(\dens, ~densVal[~currentTrack]);
						("Grain density=" ++ ~densVal[~currentTrack]).postln;

						{~trackGrainDensity[~currentTrack].string_("Grain density =" ++~densVal[~currentTrack].asString)}.defer;

					}
				)
			},






	)}
	)
})
)


