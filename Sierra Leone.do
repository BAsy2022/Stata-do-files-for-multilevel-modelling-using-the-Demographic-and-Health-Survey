**********************************Prepared by Bright Ahinkorah****25/03/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "C:\Users\User\OneDrive\Desktop\SIERRA LEONE\SIERRA LEONE NEW WGT\SLIR7AFL.DTA"

*****************MULTILEVEL MODELLING USING DHS SURVEYS*********
*This is adapted from the Zimbabwe code at the end of the DHS METHODOLOGICAL REPORTS 27**

                           ******STAGE 1*****
						   
*****Compile inputs for level-weights calculations***

*********STEP 1******
* a_c_h completed clusters by strata
gen a_c_h=.
levelsof v022, local(lstrata)
foreach ls of local lstrata {
tab v021 if v022==`ls', matrow(T)
scalar stemp=rowsof(T)
replace a_c_h=stemp if v022==`ls'
}

*********STEP 2******
* A_h total number of census clusters by strata (Table A.2 of the DHS report)
gen A_h = 0
*Urban
replace A_h = 276  if v022 == 1
replace A_h = 441  if v022 == 3
replace A_h = 201  if v022 == 5
replace A_h = 266  if v022 == 7
replace A_h = 24  if v022 == 9
replace A_h = 123  if v022 == 11
replace A_h = 207 if v022 == 13
replace A_h = 200  if v022 == 15
replace A_h = 26  if v022 == 17
replace A_h = 294  if v022 == 19
replace A_h = 323  if v022 == 21
replace A_h = 71  if v022 == 23
replace A_h = 37  if v022 == 25
replace A_h = 33  if v022 == 27
replace A_h = 635  if v022 == 29
replace A_h = 2139  if v022 == 31
*Rural
replace A_h = 615  if v022 == 2
replace A_h = 678  if v022 == 4
replace A_h = 586  if v022 == 6
replace A_h = 464  if v022 == 8
replace A_h = 330  if v022 == 10
replace A_h = 271  if v022 == 12
replace A_h = 834  if v022 == 14
replace A_h = 376  if v022 == 16
replace A_h = 409  if v022 == 18
replace A_h = 706  if v022 == 20
replace A_h = 708  if v022 == 22
replace A_h = 390  if v022 == 24
replace A_h = 579  if v022 == 26
replace A_h = 549  if v022 == 28
replace A_h = 65  if v022 == 30

*********STEP 3******
* M_h average number of population per cluster by strata (Table A.2 of the DHS report)
gen M_h = 0
*Urban
replace M_h = 94  if v022 == 1
replace M_h = 110  if v022 == 3
replace M_h = 120  if v022 == 5
replace M_h = 115  if v022 == 7
replace M_h = 68  if v022 == 9
replace M_h = 69  if v022 == 11
replace M_h = 89  if v022 == 13
replace M_h = 81  if v022 == 15
replace M_h = 118  if v022 == 17
replace M_h = 100  if v022 == 19
replace M_h = 106  if v022 == 21
replace M_h = 88  if v022 == 23
replace M_h = 121  if v022 == 25
replace M_h = 134  if v022 == 27
replace M_h = 130  if v022 == 29
replace M_h = 108  if v022 == 31

replace M_h = 93 if v022 == 2
replace M_h = 93  if v022 == 4
replace M_h = 106  if v022 == 6
replace M_h = 100  if v022 == 8
replace M_h = 76  if v022 == 10
replace M_h = 77  if v022 == 12
replace M_h = 79  if v022 == 14
replace M_h = 100  if v022 == 16
replace M_h = 105  if v022 == 18
replace M_h = 96  if v022 == 20
replace M_h = 97  if v022 == 22
replace M_h = 67  if v022 == 24
replace M_h = 99  if v022 == 26
replace M_h = 86  if v022 == 28
replace M_h = 137  if v022 == 30

*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 13399

*********STEP 5******
* M total number of households in country (Table A.1 of the DHS report)
gen M = 1265600 

*********STEP 6******
****S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the in the text of Appendix A of the DHS report)*
gen S_h = 26

*********STEP 7******
**Prepare the DHS household weight.** 
gen DHSwt = v005/1000000 

                      ******STAGE 2**
****Approximate level-1 and level-2 weights** 
*********STEP 1******
*De-normalize the final weight, using approximated normalization factor
gen d_HH = DHSwt * (M/m_c) 
*********STEP 2******
*Approximate the level-2 weight based on equal split method (α=0.5).
gen f = d_HH / ((A_h/a_c_h) * (M_h/S_h)) 
scalar alpha = 0.5 
gen wt2 = (A_h/a_c_h)*(f^alpha) 
*********STEP 3******
*Approximate the level-1 weight. 
gen wt1 = d_HH/wt2

                      *****STAGE 3**
******Sensitivity analysis*** 
**Calculate level-weights based on the following 7 scenarios of α: 0, 0.1, .25, .50, .75, 0.90 and 1.
local alphas 0 0.1 .25 .50 .75 0.90 1 
local i = 1 
foreach dom of local alphas {  
	gen wt2_`i' = (A_h/a_c_h)*(f^`dom') 
	gen wt1_`i' = d_HH/wt2_`i' 
	local ++i 
} 

****************** Stage 4 *** Svyset *** ********
svyset v001, weight(wt2_1) strata(v022) , singleunit(centered) || _n, weight(wt1_1) 

