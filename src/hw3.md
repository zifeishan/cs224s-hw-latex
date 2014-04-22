<!-- \section*{Authors}

- Zifei Shan (zifei@stanford.edu)
- Tianxin Zhao (tianxin@stanford.edu)
- Haowen Cao (caohw@stanford.edu)
 -->

 In this homework, we worked on Kaldi to tune parameters of a monophone acoustic model.

# Improve the monophone acoustic model
\label{sec:mono}
In this section, we tune 5 parameters: num_iters, max_iter_inc, totgauss, boost_silence and realign_iters. Num_iters refers to the number of Baum-Welch training the system does. The system will converges to a local optimum after certain number of iterations. We pick num_iters mainly by trial and error (50). 

Max_iter_inc is the number of last iteration to increase Gaussian and totgauss is the maximum number of Gaussian that we will use. In order to pick the best number of Gaussians to model each observation distribution, we increase the number of Gaussian once in a while. By querying to the system using gmm-info, we can see the system is using an initial #Gaussian of 62. Our choice of max_iter_inc and totgauss will decide when we will increase the Gaussians. We pick up this value by testing different combinations and decide to use a big number of totgauss (500) so that it has a large range to pick. The max_iter_inc we pick is by testing some possible values and it turns out when it is equal to num_iters (500), the system gets a lowest WER and SER. The reason of this we can think is that it will make the increase of #Gaussian slower so that the system can test on more values and keep the one that maximize the overall likelihood. 

We pick boost_silence basically by testing. Since the training/testing data is human speaker, it has some extent of silence. We increase the boost_silence to 1.2. 

Lastly, the system is doing force alignment during training to provide the inner EM a better initialization for expectation step. The inner EM of our system basically dealing with tuning the mean and variance of all the Gaussians we use, and since we change the GMM model once in a while, the inner EM restarts, which requires a good initialization. We accomplished this by forced alignment. The realign iterations should have close relation with the step size that we increase #Gaussian. We calculated the step size, which is 8, and decide we need to realign the model every 8 iterations or less. By testing, we pick 3 which gives us a good result.

We conducted a detailed experiment \ref{sec:exp} to tune parameters jointly, optimized for full datasets and normalization.

We tried training different parameters in *only* this step (without normalization and all datasets), as row 1;
We also shows our jointly optimized parameters in row 2:

\#iters         maxIterInc     totgauss       silence          realign        DATA        Normalize   WER(%)          SER(%)      
---------      -------------  ---------       ------------- ----------     ---------     ----------  ---------       ----------   
20             18             200             1               X5             1                NO       9.56              19.30 
50             50             500             1.2             X2             1                NO       10.22             19.76 

Where X2 is realigning every 3 iterations, and X5="1 2 3 4 5 6 7 8 9 10 13 16 19".

However, we realized the first row is a local optimum, because when we put
dataset 4 and normalization, the WER and SER are significantly higher
than the second parameter set:

\#iters         maxIterInc     totgauss       silence          realign        DATA        Normalize    WER(%)         SER(%)      
---------      -------------  ---------       ------------- ----------     ---------     -----------  ---------      ----------   
20             18             200             1               X5             4                YES       1.57           4.59     
50             50             500             1.2             X2             4                YES       0.97           2.89    

Therefore we conclude: parameters trained on the small dataset without normalization is not optimal. We should use the parameters obtained in Section \ref{sec:finalparam}.

# Improve feature extraction

We use the parameters in Section \ref{sec:finalparam}, and add normalization to feature extraction, and compare the results in following table, where we observe that feature normalization gives 27% WER reduction and 21% SER reduction:

\#iters         maxIterInc     totgauss       silence          realign        DATA        Normalize   WER(%)          SER(%)      
---------      -------------  ---------       ------------- ----------     ---------     ----------  ---------       ----------   
50             50             500             1.2             X2             1                NO       10.22             19.76 
50             50             500             1.2             X2             1                YES      7.44              15.63

We now use cepstrual mean and variance of one speaker to perform the feature normalization. CMVN is performed to remove the difference of training and testing environment. We compared the result of using normalization on different datasets and of different parameters, all turned out that normalization provides better result.

# Try different training data

We now have a system of WER 7.44, which leads to a 30% correct system on 16 digits bank card. We than expand our training sets.

We tried all combinations of:

- *parameters in starter script* vs *parameters in Section \ref{sec:finalparam}*
- with / without *feature normalization*
- *training set 1--4*

Results are listed in the following table:


Parameter          DATA         Normalize       WER(%)            SER(%)      
----------       ---------      ----------      ---------         ----------   
Tuned             1              NO           	   10.22            19.76
Tuned             1              YES          	   7.44            15.63
Tuned             2              NO           	   7.05            14.9
Tuned             2              YES          	   5.77            12.57
Tuned             3              NO           	   1.71            5.02
Tuned             3              YES          	   1.12            3.39
Tuned             4              NO           	   1.2            3.49
Tuned             4              YES          	   0.97            2.89
Starter             1              NO              12.32            24.41
Starter             1              YES             10.13            21.43
Starter             2              NO              9.06            20.41
Starter             2              YES             7.7            17.59
Starter             3              NO              3.97            11.31
Starter             3              YES             3.27            9.29
Starter             4              NO              3.17            8.97
Starter             4              YES             2.59            7.33

Finding:

- Dataset 3 (reduced dataset of both men and women voice) achieves similar results with the full dataset, while training with only men / women voice has much worse performance.
- Training with only women voice (dataset 2) has less testing errors than men voice.
- On average, Normalization achieves 20.96% WER reduction.
- Our parameter achieves 62.54% WER reduction (from 2.59% to 0.97%) to the optimal training with starter parameters.

# Adding extra training steps
\label{sec:delta}

Our original system use 12 dimensional MFCC features (energy feature is turned off). Now we consider the slope of the features and carry the train_deltas experiment. We train this model after train_mono so that we have a good initialization of EM.

By adding extra training steps, we boost WER to 0.79% and SER to 2.41%, with `numleavs=100` and `totgauss=800`.

We tune `numleaves` and `totgauss` based on a random sampling from parameter space. We sampled 6 combinations:

- We found that extra training with a delta feature do not always improve WER / SER. In fact, improper values of "numleaves" (initial numbers of gaussians) and "totgauss" (maximum gaussians) would even increase errors. (e.g. numleaves=10, totgauss=500, WER increase from 0.97 to 2.27)
- When numleaves=100, totgauss=800, errors are decreased by 18.5% (WER) / 16.6% (SER).

delta     numleaves    totgauss        WER(%)        SER(%)
------    -----------  -------------  -----------   --------------
BEFORE          10          500          0.97          2.89
AFTER           100         800        **0.79**      **2.41**
AFTER           300         1200          0.98          2.86
AFTER           500         1200          1.02          2.83
AFTER           500         800          1.21          3.48
AFTER           800         800          1.22          3.41
AFTER           10         800          1.97          5.99
AFTER           100         100          1.98          5.75
AFTER           16         800          2.07          6.26
AFTER           10         500          2.27          6.83
AFTER           16         100          3.33          9.76

Adding delta features will not always improve the result based on different training set we pick. For small training set, more features may lead to overfitting and thus a worse result. 

Below is a comparison between transcribed file with and without delta training.

No Delta:

ac_33o31a  [ 4 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 16 15 18 17 ] [ 122 121 121 121 124 123 123 126 125 125 ] [ 104 103 106 105 108 107 ] [ 62 61 64 66 65 65 ] [ 122 121 121 121 121 121 121 121 124 123 123 123 126 125 125 ] [ 104 106 105 108 107 ] [ 62 61 61 61 61 64 63 66 65 65 ] [ 86 85 85 85 85 85 85 85 85 85 85 85 85 85 88 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 90 89 89 89 89 89 89 89 89 ] [ 4 14 15 15 11 10 10 10 10 10 10 10 10 16 15 15 15 15 15 15 15 15 15 15 18 ] [ 122 121 121 121 124 123 123 123 123 126 125 125 125 ] [ 104 106 108 107 ] [ 62 61 61 64 66 65 65 65 ] [ 50 49 49 49 49 49 49 49 49 52 51 51 51 54 53 53 53 53 53 53 53 53 53 53 ] [ 80 79 79 82 81 81 81 81 84 83 83 ] [ 74 73 73 76 75 75 78 77 77 77 ] [ 4 1 1 1 16 18 17 17 17 17 17 17 17 17 17 17 17 17 17 ] 

ac_33o31a  sil                                             th                                          r                           iy                    th                                                              r                       iy                                ow                                                                                                                                sil                                                                           th                                                      r                   iy                          w                                                                           ah                                   n                                 sil                          

33031

Has Delta:

ac_33o31a  [ 4 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 16 18 ] [ 122 121 121 121 121 121 121 124 126 ] [ 104 106 108 107 ] [ 62 61 61 61 61 61 61 64 66 ] [ 4 1 1 16 18 ] [ 122 121 121 121 121 121 121 124 126 ] [ 104 106 108 ] [ 62 61 61 61 61 61 61 61 61 61 64 66 ] [ 86 88 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 87 90 ] [ 4 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 16 18 ] [ 122 121 121 121 121 121 121 121 121 121 124 126 ] [ 104 106 108 ] [ 62 61 61 61 61 61 61 61 64 66 ] [ 50 49 49 49 49 49 49 49 49 49 49 49 49 49 49 49 49 49 49 49 49 52 54 ] [ 80 82 81 81 81 81 81 81 81 81 84 ] [ 74 73 73 73 73 73 76 78 ] [ 4 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 16 18 ] 

ac_33o31a  sil                                           th                                      r                   iy                             sil             th                                      r               iy                                      ow                                                                                                                             sil                                                         th                                                  r               iy                                w                                                                        ah                                   n                           sil   

33031

Both with or without delta interpret this stream as the same digit string "33031", but we can see that delta detected another SIL which is possibly due to its sensitivity to the slope of feature.

# Extra credit

## Combinations of monotone and delta training

For extra credit, we also tried delta training for the parameter optimized for Question 1 \ref{sec:mono} (Alternative parameters)
*20,18,100,1,1 1 2 3 4 5 6 7 8 9 10 13 16 19', normalized, trained on dataset 4*, and starter parameters.

The results are reported in following table:

Alternative parameters:

delta     numleaves    totgauss        WER(%)        SER(%)
------    -----------  -------------  -----------   --------------
BEFORE          /          /             1.57          4.59
AFTER          200          300         1.40          4.17
AFTER          100          300         1.34          4.05
AFTER          100          800         1.01          3.05
AFTER          200          800         0.96          2.84
AFTER          100          1200         0.90          2.75
AFTER          200          1200         0.80          2.44


Starter parameters:

delta     numleaves    totgauss        WER(%)        SER(%)
------    -----------  -------------  -----------   --------------
BEFORE          /          /             9.06            20.41
AFTER          100          1600          12.86          23.54
AFTER          300          1200          7.47          16.22
AFTER          500          1200          8.27          17.33
AFTER          500          800          7.84          16.66
AFTER          800          1200          8.76          18.16
AFTER          800          800          7.64          16.7

We see none of those training get better numbers than our optimal number (0.79%, 2.41%).


## Training with energy

We tried training with *energy* (in `mfcc.conf`) on our best parameters, but the WER increases to 
- 1.20% WER, 3.53% SER with mono-training only.
- 0.90% WER, 2.72% SER with delta training.

Which is not as good as numbers without energy.

\newpage

\section*{Appendix 1: Experiments}
\label{sec:exp}

We experimented on the the four parameters `num_iters`, `max_iter_inc`, `totgauss`, `boost_silence`, `realign_method`. 

To restrict parameter space, we defined **4 realign methods**: "realign" X1--X4 means `realign_iters=`:

- X1:	'1 2 3 4 5 6 7 8 9 10 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 55 57 59 61 63 65 67 69 71 73 75 77 79 81 83 85 87 89 91 93 95 97 99'
- X2:	'1 4 7 10 13 16 19 22 25 28 31 34 37 40 43 46 49 52 55 58 61 64 67 70 73 76 79 82 85 88 91 94 97'
- X3:	'1 2 3 4 5 6 7 8 9 10 12 14 16 18 20 23 26 29 32 35 38 44 46 52 58 62 74 86 98'
- X4:	'1 11 21 31 41 51 61 71 81 91'


## Experimental Choice

We realize that optimal parameters trained based on Question 1 (with
less data and no normalization) might be not optimal with more data and
normalization. Therefore, we decide to train parameters with a larger
dataset and normalization, i.e. directly select parameters for Question
3.

## Initial random sampling

First we **sampled random combinations** of parameters. (We trained with --fake flage removed, but this should not affect result):

\#iters     maxIterInc   totgauss    silence         realign   DATA     Normalize       WER(%)   SER(%) 
---------  -----------  --------    -------------   -------   -------  --------------- ------    --------
100        15           1000        1.25            X1        1        YES             9.65       18.33   
100        15           700         1.25            X2        1        YES             8.58       17.07   
100        20           1000        1.35            X3        1        YES             10.05      19.41   
50         15           1000        1.25            X4        1        YES             9.76       19.54   
50         15           500         1.25            X3        1        YES             8.39       16.72   
50         50           500         1.00            X3        1        YES             *7.71*     *16.32* 

We found that approximately the combination (50,50,500,1.0, X3, 1) has good results. So we tuned arguments around that.

## Single argument tuning

Tuning `num_iters` and `max_iter_inc`: 

- We found that `num_iters` and `max_iter_inc` go up to 50, the performance increase significantly. 
- As they increase from 50 to 100 the performance do nit increase much.

\#iters         maxIterInc     totgauss       silence          realign        DATA         Normalize         WER(%)       SER(%)            
---------      -------------  ---------       -------------    -------        ------      ---------------    --------    ----------              
20             15             500             1.25             X4             4              NO                1.76          5.17      
20             15             800             1.25             X4             4              NO                1.76          5.10      
30             20             500             1.25             X4             4              NO                1.41          4.18      
50             30             500             1.25             X4             4              NO               *1.23*        *3.64*     
100            50             500             1.25             X4             4              NO                1.28          3.75      

Tuning `max_iter_inc`:

- We fix `num_iters` to 50 and tune `max_iter_inc`.
- Surprisingly, when `max_iter_inc` goes from 10 to 40, WER decreases and then increases; when `max_iter_inc=50`, WER decreases again to minimum. 

\#iters         maxIterInc     totgauss       silence          realign        DATA       Normalize          WER(%)          SER(%)         
---------      -------------  ---------       ------------- ----------     ---------    ---------------    ---------       ----------           
50             50             500             1.2             X2             4             YES              *0.97*           *2.89*    
50             40             500             1.2             X2             4             YES               1.15             3.38     
50             30             500             1.2             X2             4             YES               1.03             3.05     
50             20             500             1.2             X2             4             YES               1.05             3.09     
50             10             500             1.2             X2             4             YES               0.99             2.95     

Tuning `totgauss`:

- We found that as `totgauss` go from 500 to 800, the performance almost do not change.

\#iters         maxIterInc     totgauss       silence          realign        DATA      Normalize        WER(%)          SER(%)     
---------      -------------  ---------       -------------    -------        ------   ---------------   --------      ---------  
20             15             500             1.25             X4             4           NO               1.76        5.17    
20             15             800             1.25             X4             4           NO               1.76        5.10    

Tuning `boost_silence` (--fake removed):

- We found that when `boost_silence=1.20` the result is the best among these choices. 

\#iters         maxIterInc     totgauss       silence          realign        DATA        Normalize          WER(%)        SER(%)         
---------      -------------  ---------       -------------   --------       -------     ---------------     --------     ----------           
50             50             500             1.00            X2             4              YES               1.03           3.02      
50             50             500             1.10            X2             4              YES               0.98           2.91     
50             50             500             1.20            X2             4              YES              *0.97*         *2.89*    
50             50             500             1.25            X2             4              YES               1.00           2.99     

Tuning `realign_iters` (--fake removed):

- We found that our "`X2`" method has the best performance. This method realigns frames *every 3 iterations*. 
- `X3` also achieves good results, which realigns every iteration before 10th iterations, every other iteration before 20th, and gradually reduces realignments as `#iterations` goes up.
- It turns out that either too frequent or infrequent realignment increases WER.
 
\#iters         maxIterInc     totgauss       silence          realign        DATA      Normalize         WER(%)          SER(%)         
---------      -------------  ---------       ------------- ----------     ---------   ---------------   ---------       ----------           
50             50             500             1             X3             4              YES            1.05             3.15       
50             50             500             1             X4             4              YES            1.14             3.38       
50             50             500             1             X1             4              YES            1.13             3.32       
50             50             500             1             X2             4              YES            *1.03*           *3.02*     

## Final parameters
\label{sec:finalparam}

Based on the experiments above, we choose the final parameters:


		num_iters=50       # Number of iterations of training
		max_iter_inc=50    # Last iter to increase #Gauss on.
		totgauss=500       # Target #Gaussians.  
		boost_silence=1.20 # Factor by which to boost silence likelihoods
		realign_iters='1 4 7 10 13 16 19 22 25 28 31 34 37 40 43 46 49 
						52 55 58 61 64 67 70 73 76 79 82 85 88 91 94 97'





<!-- 

=== Word Error Rates ===
%WER 0.97 [ 278 / 28583, 88 ins, 109 del, 81 sub ] exp/mono0a/decode/wer_17
%WER 3.42 [ 978 / 28583, 228 ins, 471 del, 279 sub ] exp/tri1/decode/wer_19
=== Sentence Error Rates ===
%WER exp/mono0a/decode/wer_17:%SER 2.89 [ 251 / 8700 ]
%WER exp/tri1/decode/wer_19:%SER 10.00 [ 870 / 8700 ]


 -->









<!-- 
20 15 500 1.25 2:
=== Word Error Rates ===
%WER 7.42 [ 2120 / 28583, 300 ins, 615 del, 1205 sub ] exp/mono0a/decode/wer_19
=== Sentence Error Rates ===
%WER exp/mono0a/decode/wer_18:%SER 15.95 [ 1388 / 8700 ]


 20 15 500 1.25 1 
## Align too hard (1): 
=== Word Error Rates ===
%WER 11.23 [ 3210 / 28583, 760 ins, 348 del, 2102 sub ] exp/mono0a/decode/wer_19
=== Sentence Error Rates ===
%WER exp/mono0a/decode/wer_19:%SER 20.63 [ 1795 / 8700 ]

 20 15 500 1.25 4 
## Align 4: every 10 passes 
=== Word Error Rates ===
%WER 1.76 [ 503 / 28583, 147 ins, 231 del, 125 sub ] exp/mono0a/decode/wer_18
=== Sentence Error Rates ===
%WER exp/mono0a/decode/wer_18:%SER 5.17 [ 450 / 8700 ]

20 15 800 1.25 4
0.000374034 0

=== Word Error Rates ===
%WER 1.76 [ 502 / 28583, 151 ins, 232 del, 119 sub ] exp/mono0a/decode/wer_17
=== Sentence Error Rates ===
%WER exp/mono0a/decode/wer_17:%SER 5.10 [ 444 / 8700 ]

30 20 500 1.25 4
0.000374034 -0.000329226

=== Word Error Rates ===
%WER 1.41 [ 403 / 28583, 104 ins, 196 del, 103 sub ] exp/mono0a/decode/wer_18
=== Sentence Error Rates ===
%WER exp/mono0a/decode/wer_18:%SER 4.18 [ 364 / 8700 ]


50 30 500 1.25 4
0.000374034 -0.000290811

=== Word Error Rates ===
%WER 1.23 [ 353 / 28583, 138 ins, 125 del, 90 sub ] exp/mono0a/decode/wer_15
=== Sentence Error Rates ===
%WER exp/mono0a/decode/wer_16:%SER 3.64 [ 317 / 8700 ]

...

results/100-15-1000-1.25-1:%WER 9.65 [ 2759 / 28583, 653 ins, 301 del, 1805 sub ] exp/mono0a/decode/wer_19
results/100-15-1000-1.25-1:%WER exp/mono0a/decode/wer_19:%SER 18.33 [ 1595 / 8700 ]
results/100-15-700-1.25-2:%WER 8.58 [ 2453 / 28583, 586 ins, 355 del, 1512 sub ] exp/mono0a/decode/wer_19
results/100-15-700-1.25-2:%WER exp/mono0a/decode/wer_19:%SER 17.07 [ 1485 / 8700 ]
results/100-20-1000-1.35-3:%WER 10.05 [ 2874 / 28583, 641 ins, 401 del, 1832 sub ] exp/mono0a/decode/wer_19
results/100-20-1000-1.35-3:%WER exp/mono0a/decode/wer_19:%SER 19.41 [ 1689 / 8700 ]
results/50-15-1000-1.25-4:%WER 9.76 [ 2791 / 28583, 654 ins, 498 del, 1639 sub ] exp/mono0a/decode/wer_19
results/50-15-1000-1.25-4:%WER exp/mono0a/decode/wer_19:%SER 19.54 [ 1700 / 8700 ]
results/50-15-500-1.25-3:%WER 8.39 [ 2397 / 28583, 617 ins, 289 del, 1491 sub ] exp/mono0a/decode/wer_19
results/50-15-500-1.25-3:%WER exp/mono0a/decode/wer_19:%SER 16.72 [ 1455 / 8700 ]
results/50-50-500-1.0-3:%WER 7.71 [ 2204 / 28583, 451 ins, 335 del, 1418 sub ] exp/mono0a/decode/wer_19
results/50-50-500-1.0-3:%WER exp/mono0a/decode/wer_18:%SER 16.32 [ 1420 / 8700 ]

# 3rd

=== Word Error Rates ===
%WER 1.06 [ 302 / 28583, 95 ins, 138 del, 69 sub ] exp/mono0a/decode/wer_16
=== Sentence Error Rates ===
%WER exp/mono0a/decode/wer_16:%SER 3.20 [ 278 / 8700 ]

 -->
