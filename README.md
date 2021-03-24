Here i am going to publish my ideas and dummy instruments related to 32 BTC Puzzle [1]. 

Shortly, the "32 BTC Puzzle" is not a puzzle at all but rather a bruteforce BenchMark or specific BruteForcing contest that aimed to compose fast and reliable instrument for BTC Private Keys bruteforce from one hand and to check how the BTC cryptography is secure at the moment. 
 
In 2015(+2017), someone made a series of transactions to a series of specific BTC addresses [2].

In 2015 addresses contained 32 BTC, but in 2017 the creator has increased this value for more than 100 BTC ( and most of them are still there to be spent by smart guys, luckers or by the creator)

BTC Private Key (the thing that provides an access to funds stored under the specific BTC address) is an integer value of a 256 bits length (256 of {0 or 1}) or 64 HEXadecimal (16 base) values. The BTC address taken from the explorer above[2] actually obtained form an appropriate (and unknown) BTC private keys through a series of HASHING procedures that takes computing time. Generally, to find the Private Key for the specific BTC address cracker will need to try all 2<sup>256</sup> ({0/1} x {0/1} x ... {0/1}) possible Private Keys, generating a BTC address for each and comparing with the address of interest.

This number 2<sup>256</sup> is so huge (~10<sup>77</sup> combinations) that with a typical GPU speed of ~ 10<sup>8</sup>-10<sup>9</sup> Private Keys per second one BTC address brutting on typical PC (recovering the Private Keys for the specific BTC address by looping through all possible BTC Private Keys) will require time larger than a Universe is believed to be existed.

BUT, a special thing about these "32 BTC" addresses is such that their Private Keys are partially known:
```
#1 000...<255>...0001
#2 000...<254>...001x
#3 000...<253>...01xx
#4 000...<252>...1xxx
 ... 
#n 000...<256-n>...1xx<n-1>xx
```
The n-th Private Key constructed with (256-n) zeroes, 1, and (n-1) random bits. The complexity of bruting (n+1)-th key obviously is twice the complexity of the n-th key but in the same time it store more BTC. Currently, #1 - #63 are brutted and BTC stored there have been spent leaving #64 as the next easiest target from the list. Expected complexity - amount of Private Keys required to be processed in order to find an appropriate one - is 2<sup>63</sup> = ~10<sup>19</sup> that will require 50 billion of seconds or ~1500 years on RTX 2070 (at least my mobile RTX 2070 provided 200 MKeys/s using CUDA 10.1 and BitCrack project [3]). Seems impossible to successfully brute #64 simply looping through all 2<sup>63</sup> Private Keys on typical PC. #65 will be twice harder requiring ~3000 years on RTX 2070 and so on. Probably, the bruteforce instrument could be optimized to run nearly at ~ 1000 MKeys/s on the same RTX 2070, but having even 300 of such RTX 2070 cards will reduce the processing time for #64 to ~ 1 year and thats for a 0.64 BTC bounty thats a great money but not in a context of 1 year exploitation of 300 of TOP GPUs (you may estimate amount of BTC it could produce mining ETH OR just compare 0.64 BTC with the price of 300 of RTX 2070 now). Thats why the idea that there are some logic behind the xxx<n-1>xx sequence of bits is so delicious - it is nearly impossible to loop through all 2<sup>n-1</sup> combination on PCs of poor guys like me (i was luckily to be gifted with RTX 2070 laptop) but estimating the exact value of the Private Key or at least dramatically narrow the range of values to be brutted should increase our chances in this race (do not forget - there are lots of other smart seekers and some of them have huge computational power).

Private Keys for #1-#63 and #65, #70, #75, #80, #85, #90, #95, #100, #105, #110 and #115 are already known. The first was bruted in a classic way (Private Key -> Public Key -> BTC address) while the next 5th keys were brutted due to another useful leakage - the author have "opened" their Public Keys (making a transaction from each 5th address of very small BTC amount) that helped to decrease complexity of bruteforce for all 5th keys nearly in square root ( #120 would be ~2<sup>60</sup> instead of 2<sup>120</sup>) using a Kangaroo algorithm [4]. All known Private Keys in decimal notation are written on the file "btc32_keys_dec.csv" (folder "BTC32_Analysis") or also could be found in "BTC32_BitCrack_Test.txt". 

Folder "BTC32_analysis" contains my dummy analysis of already known Private Keys. In order to compare Private Keys for different BTC addresses and so different amount of unknown bits it was decided to transform them from large integers of the form PK<sub>n</sub> = 2<sup>n-1</sup> + rem where rem taken from {0...2<sup>n-1</sup>} into "dimensionless" form alpha<sub>n</sub> = (PK<sub>n</sub> -2<sup>n-1</sup>) / 2<sup>n-1</sup>. Alpha parameter for all Private Keys shows the relative position of the Private Key inside its interval of possible values and lies in interval of {0..1} for all BTC addresses. 

MATLAB script BTC32_dummy_analysis.m computes simple statistical values presenting them in graphical form (alpha values are also printed in file - alpha.csv).

![raw_alpha](https://user-images.githubusercontent.com/80585811/111080519-7ccce480-8507-11eb-97c5-51f4475936e2.png)


At first view, it is hard to find some pattern in the data - only a tendency of acquiring values closer to the center (0.5) comes to mind. The script builds a histogram for alphas (amount of Private Keys alpha values that lies in specific narrow interval VS narrow interval position) in order to inspect this probabilistic nature. Histograms plotted for: the #1-#63 Private keys, #65, #70...#115 Private Keys, for all them together with different "sub intervals" (histogram bins width).

![hist_1_63](https://user-images.githubusercontent.com/80585811/111080570-b7cf1800-8507-11eb-88dc-6077864b93b3.png)
![hist_upper_5th](https://user-images.githubusercontent.com/80585811/111080578-bef62600-8507-11eb-8482-1056b5288787.png)
![hist_all](https://user-images.githubusercontent.com/80585811/111080580-c4537080-8507-11eb-9cc3-2bb6096ca752.png)


And here it really seems like the Private Keys are more probable to be found at {0.3-0.5} and {0.6-0.8}. The special case is {0.82-0.83} where few Private Keys lied closely that is seen from the histogram with small bins/bars.

One may assume here a few scenarios: 1) there is a tendency for Private Keys to be distributed along those intervals (histogram maxima) with higher probability that means that the next yet uncovered Private Keys will more probable have alpha values inside those intervals (histogram maxima) than outside of them; 2) the whole dataset should be distributed along the whole interval {0...1} more evenly that means that the next yet uncovered Private Keys will more probable have alpha values that lies outside histogram maxima OR inside histogram minima intervals. Both ideas is aimed to reduce an amount of brutted keys while remain the probability of brutting success at a reasonable or at least acceptable level. There is also a third scenario - each Private Key is generated using a strong (good) Random Generator and so all of them are uniformly distributed - the histogram has its peaks due to small "observations number" (Uncovered Private Keys).

Script "BTC32_dummy_simulation.m" plays with numbers generated in a similar to 32BTC Private Keys way - but using smaller number values (MATLAB has a limited Random Generator precision). The resulting histograms examples for the first 60s numbers and the rest 100 numbers compared below (try it yourself - you will see that 1 and 2 mentioned scenarios and a strategy they formed could be a mistake - the histogram for the first 60s numbers doesn't linked with the rest 100s histogram.

Reducing search intervals in 10, 100, 1000 or even 10 000 times or forming a series of such narrow intervals with high Private Keys recovering probability could strongly improve a success mathematical expectation (that is possible only if 1 or/and 2 scenarios are true) but still is not enough for slow PCs of ours forcing us to lurk for even easier in sence of required computational power way - mania of patterns, just like in a "A Beautiful Mind" film. Only thing here that should be clearly stated is that a model you are using for prognosis should have a number of parameters less than a number of observations - simple polynomial approximation with an order of n will ideally fit the dataset of n points (it will have exactly n roots) just memorizing the data instead of retrieving the logic behind the data - same correct for complex models like SVM or neural networks - they could just memorize (overfit) the data but in a less obvious way - so be carefull using them or you will lose your precious time for mathematical madness. 

One that could be said definitely - there is no any linear tendency or relation in data that is shown by its correlation. Autocorrelation looks just like a noise autocorrelation.

![autocorr_1_63](https://user-images.githubusercontent.com/80585811/111080604-e3520280-8507-11eb-839e-8ebd26ec61bb.png)
![autocorr_upper_5th](https://user-images.githubusercontent.com/80585811/111080609-e816b680-8507-11eb-9eba-118dfb3e3318.png)

Nevermind, folders "BTC32_Brute_GenTask" and "BTC32_Brute" are made to simplify the process of running the BruteForce on several tiny intervals of alpha values for a specific BTC addresses.

At first, you need to generate the "task_file.txt" using "GenerateTask.m" (MATLAB\Octave script: for example "octave GenerateTask.m", you will need an octave or MATLAB for this step) - to do so specify the BTC addresses you are willing to brute along with their indices (amount of unknown bits) in file "Pzl32_unspentList.csv":
```
....
66,"13zb1hQbWVsc2S7ZTZnP2G4undNNpdh5so"
67,"1BY8GQbnueYofwSuFAT3USAhGjPrkxDdW9"
....
```
and specify alpha values / interval width inside the "GenerateTask.m" script (see the comments inside the script, shortly - Brute_MKs is expected bruteforce speed in million keys per second / Run_TimeOut_m is desired timeout for bruteforce / alpha_to_seek are desired alpha values given in [] brackets):
```
...
BruteRate_MKs = 200;
Run_TimeOut_m = 10;
MAX_Keys_interval = ceil(vpa(BruteRate_MKs * (10^6) * Run_TimeOut_m * 60, vpa_acc));
alpha_to_seek = vpa([0 0.0078125 0.75 0.82207866191468159655642011784948 0.82817983680743556540448935265886 1], vpa_acc);
...
```
Run the script "GenerateTask.m" to generate the "task_file.txt" that will look like following:
```
...
66,0.000000,1FFFFFFFFFFFFFFFF:20000001BF08EB000,13zb1hQbWVsc2S7ZTZnP2G4undNNpdh5so
66,0.007813,203FFFFF207B8A800:20400000DF8475800,13zb1hQbWVsc2S7ZTZnP2G4undNNpdh5so
66,0.750000,37FFFFFF207B8A800:38000000DF8475800,13zb1hQbWVsc2S7ZTZnP2G4undNNpdh5so
66,0.822079,3A4E77E815B2D2800:3A4E77E9D4BBBD800,13zb1hQbWVsc2S7ZTZnP2G4undNNpdh5so
66,0.828180,3A8072FF69E884800:3A80730128F16F800,13zb1hQbWVsc2S7ZTZnP2G4undNNpdh5so
66,1.000000,3FFFFFFE40F715000:40000000000000001,13zb1hQbWVsc2S7ZTZnP2G4undNNpdh5so
67,0.000000,3FFFFFFFFFFFFFFFF:40000001BF08EB000,1BY8GQbnueYofwSuFAT3USAhGjPrkxDdW9
67,0.007813,407FFFFF207B8A800:40800000DF8475800,1BY8GQbnueYofwSuFAT3USAhGjPrkxDdW9
...
```
Finally, place the generated "task_file.txt" in the folder "BTC32_Brute". Before running the script "BTC32_narrow_search.sh" - you'll need to place a BitCrack project folder taken from [1] (OR unzip the BitCrack-master.zip), compile it (CUDA\CL) and modify "BTC32_narrow_search.sh" to suite your version of BitCrack (see the script comments). The script will simply loop through all lines of "task_file.txt" running them through the BitCrack. The results and debug info will be stored in unique folder - example could be found in "BTC32_Brute_Examples" (read the comments of the script).

Before the real job - i'd recommend you to test your setup with some already "solved/spent" Private Keys. 
Good example of such test you may find in "BTC32_Brute_Examples" - "output_LYoc8Q" where two BTC addresses are brutted with alphas taken from "BTC32_analysis/alpha.csv":
[Pzl32_unspentList.csv]:
```
53,"15K1YKJMiJ4fpesTVUcByoz334rHmknxmT"
55,"1LzhS3k3e9Ub8i2W1V8xQFdB8n2MYCHPCa"
```
[GenerateTask.m]:
```
...
alpha_to_seek = vpa([0.5018395352846268 0.6678542153963616], vpa_acc);
...
```
Resulted in the next status_all.txt - my setup expected up to 9.5-10 minutes: so the job have taken 9.5-10 min for bad alphas (where the Private Key true alpha lied outside the seek interval) and up to half of this time for good alphas (where the output file with retrieved Private Keys has been composed - see an example folder for details):
```
53 0.501840 18077AEC36DA6C:180796DCC58A6C 15K1YKJMiJ4fpesTVUcByoz334rHmknxmT DONE real 4m43,159s user 0m36,045s sys 0m33,181s
53 0.667854 1AAF79EE92A045:1AAF95DF215045 15K1YKJMiJ4fpesTVUcByoz334rHmknxmT DONE real 9m27,197s user 1m12,556s sys 1m0,663s
55 0.501840 601E1599B171B0:601E318A4021B0 1LzhS3k3e9Ub8i2W1V8xQFdB8n2MYCHPCa DONE real 9m28,337s user 1m12,578s sys 1m0,499s
55 0.667854 6ABE11A3208914:6ABE2D93AF3914 1LzhS3k3e9Ub8i2W1V8xQFdB8n2MYCHPCa DONE real 4m44,704s user 0m36,757s sys 0m30,376s
```

The comment from an author of this contest (BTC 32 Puzzle) could be found on the mentioned bitcointalk topic [1']
```
....
A few words about the puzzle.  There is no pattern.  It is just consecutive keys from a deterministic 
wallet (masked with leading 000...0001 to set difficulty).  It is simply a crude measuring instrument, 
of the cracking strength of the community.

Finally, I wish to express appreciation of the efforts of all developers of new cracking tools and 
technology.  The "large bitcoin collider" is especially innovative and interesting!
....
```
Seems like the author does not protest against hacking, but on the contrary encourages both hacking and the development of tools that facilitate hacking (perhaps having an ulterior motive -  somewhere outside bitcoin there could be a less secure cryptographic system that will be hacked using tools we are developing solving this "32BTC puzzle")

## P.S.
Now (15/03/2021) i'm going to work on my PhD thesis, expecting to return (get back in working on BTC Puzzles) in one month (~15/04/2021). Thank you for spending time on my notes, i hope it was not totally useless and you've found something interesting. 

Any ideas\questions or propositions you may send to generalizatorSUB@gmail.com.

-------------------------------------------------------------------------
### References:
[1] BTC32 Bitcointalk topic - https://bitcointalk.org/index.php?topic=1306983.0

[1'] BTC32 Bitcointalk topic, author message - https://bitcointalk.org/index.php?topic=1306983.msg18765941#msg18765941

[2] BTC32 transactions/addresses - https://www.blockchain.com/btc/tx/08389f34c98c606322740c0be6a7125d9860bb8d5cb182c02f98461e5fa6cd15

Here are links to the awesome projects i've refered to (many thanks for your work guys, all the bitcointalk thread really apreciate your efforts) :

[3] "BitCrack" project - https://github.com/brichard19/BitCrack

[4] "Kangaroo" project - https://github.com/JeanLucPons/Kangaroo

-------------------------------------------------------------------------
### Support
I am poor Ukrainian student that will really appreciate any donations.
I have no home (flat\appartment), live in the dorm trying to accumulate funds
for the smallest flat in the city - with no success at the moment,
have nearly 10% of needed amount.

**BTC**:  `1QKjnfVsTT1KXzHgAFUbTy3QbJ2Hgy96WU`

**LTC**:  `LNQopZ7ozXPQtWpCPrS4mGGYRaE8iaj3BE`

**DOGE**: `DQvfzvVyb4tnBpkd3DRUfbwJjgPSjadDTb`
