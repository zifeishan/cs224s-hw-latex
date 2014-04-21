\section*{Authors}

Zifei Shan (zifei@stanford.edu)


# 

## Error rate:

- Tested 76 words on Siri. 
- Input: a paragraph on this problem set.
- Result: make errors on 10 words.

## Error characterization:

- do not have punctuation
- recognize some phrases as others. The output phrases are correct

## barge-in:

Siri allows barge-in as long as you push the speak button before speaking. The system will stop speaking and take input. If you just speak without pushing the button, it cannot hear you.

# Calendar appointments

Used Siri to create event "meet with Denny and Tim at lab on next Monday 9AM".

Problem: both recognition and other logic

- recognition problem:
	- hard to recognize person names I don't have in contact book (Denny and Tim) 
- Other problems:
	- If a recognition error is made, it will forget about current transaction in making the appointment and I have to restart.
	
# Appointment

I tried several commands and found several errors:

- "Find an Israeli restaruant": cannot recognize the word "Israeli".
- "Find Orens Hummus shop": cannot recognize either "Orens" or - "Hummus".
- "Find a restaruant on University Avenue": cannot find "University Avenue" in Palo Alto.

The first two are recognization errors; the last one is missing data.

# TTS

Tested with Mac "say" command.

1. "What a wonderful course": "wonderful" too much stress on "ful".
2. "Hmm...": weird tone
3. 'Yahoo and Google, which is better?': weird raising tone on "better".
4. 'Try to be creative' and 'Try to be creative!': slight and weird difference on emphasis.
5. "I'd rather believe that he can't do it": "can't" pronounced as "can".

# Errors:

- three [th r iy]
- sing [s ih ng]
- eyes [ay z]
- study [s d ah dx i]
- though [dh ow]
- planning [p l ae n ih ng]
- slight [s l ay t]

# Transcribe

- red [r eh d]
- blue [b l uw]
- green [g r iy n]
- yellow [y eh l ow]
- black [b l ae k]
- white [w ay t]
- orange [aa r ih n zh]
- purple [p axr p el]
- dark [d aa r k]
- suit [s y uw t]
- greasy [g r iy s ih]
- wash [w aa sh]
- water [w aa dx axr]

# 

## 

Police say 
Elizebeth Levy
was driving 50 miles an hour
in a 30-mile zone
around midnight
on July 15th.

## 

Yeah, but there's really no written rule.

# Praat

ARPAbet sequences:

## Boston news:

p el l ih s ey ih l ih z eh b eh th l iy v ih w eh z dr r ay v ih ng f ih f t ih m ay el z n aw er ih n eh th er dx ih m ay el z ow n ah r aw n m ih q n ay t ah n zh uh l ay f ih f t iy n th

## Switchboard:

iy eh ae b eh dh eh r sh r ih el ih n ow r ih n r uh el

## Pictures

See Figure \ref{fig:draw}.

\begin{figure*}[!b]
\centering
\subfigure[Boston Radio News]{ 
    \includegraphics[width=0.8\textwidth]{img/hw1-praat-bostonnews.eps}
}
\subfigure[SwitchBoard]{ 
    \includegraphics[width=0.8\textwidth]{img/hw1-praat-switchboard.eps}
}
\caption{Praat Draw Picture}
\label{fig:draw}
\end{figure*}

# Pitch

- Boston news:
	- min: 86.88 Hz
	- max: 214.68 Hz
- Switchboard:
	- min: 154.44 Hz
	- max: 376.28 Hz
	
# Differences

- Transcription differences: 
  - Boston news is more similar with dictionary ARPAbet tones.
	- Switchboard is more casual, and has more changes to standard (dictionary) tones.
	
- Pitch range: 
	- Switchboard has a higher pitch range than Boston news.

- Others:
	- In Switchboard, the duration of some emphasized words *(yeah / rules)* are longer than standard, and the duration of other words are shorter *(but there's really no)*.

The difference of human-human speech and human-machine speech can play a causal role in the differences I found.  Human-machine speech is used for automated speech recognition, so the speech is more standard and formal, while human-human speech is more casual.
