**********************************Prepared by Bright Ahinkorah****31/05/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/ZA_2016_DHS_01302020_659_129249/ZAIR71DT/ZAIR71FL.DTA"


****Compile inputs for level-weights calculations***

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
replace A_h = 7251  if v022 == 1
replace A_h = 4626  if v022 == 3
replace A_h = 1209  if v022 == 6
replace A_h = 3707  if v022 == 9
replace A_h = 6482  if v022 == 12
replace A_h = 2434  if v022 == 15
replace A_h = 16177  if v022 == 18
replace A_h = 2451  if v022 == 21
replace A_h = 1314  if v022 == 24
*Traditional
replace A_h = 4636  if v022 == 4
replace A_h = 283  if v022 == 7
replace A_h = 453  if v022 == 10
replace A_h = 4917 if v022 == 13
replace A_h = 2471  if v022 == 16
replace A_h = 220  if v022 == 19
replace A_h = 2849  if v022 == 22
replace A_h = 6385  if v022 == 25
*Faram
replace A_h = 368  if v022 == 2
replace A_h = 247  if v022 == 5
replace A_h = 284  if v022 == 8
replace A_h = 361  if v022 == 11
replace A_h = 760  if v022 == 14
replace A_h = 305  if v022 == 17
replace A_h = 234  if v022 == 20
replace A_h = 385  if v022 == 23
replace A_h = 432  if v022 == 26


*********STEP 3******
* M_h average number of population per cluster by strata (Table A.2 of the DHS report)
gen M_h = 0
*Urban
replace M_h = 217  if v022 == 1
replace M_h = 194 if v022 == 3
replace M_h = 183  if v022 == 6
replace M_h = 191  if v022 == 9
replace M_h = 226  if v022 == 12
replace M_h = 209  if v022 == 15
replace M_h = 250  if v022 == 18
replace M_h = 208  if v022 == 21
replace M_h = 220  if v022 == 24
*Traditional
replace M_h = 170  if v022 == 4
replace M_h = 181  if v022 == 7
replace M_h = 163 if v022 == 10
replace M_h = 196  if v022 == 13
replace M_h = 196  if v022 == 16
replace M_h = 177  if v022 == 19
replace M_h = 174  if v022 == 22
replace M_h = 166  if v022 == 25
*Farm
replace M_h = 329  if v022 == 2
replace M_h = 189  if v022 == 5
replace M_h = 128  if v022 == 8
replace M_h = 153  if v022 == 11
replace M_h = 255  if v022 == 14
replace M_h = 326  if v022 == 17
replace M_h = 262  if v022 == 20
replace M_h = 242  if v022 == 23
replace M_h = 213  if v022 == 26


*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 11083 

*********STEP 5******
* M total number of households in country (Table A.1 of the DHS report)
gen M = 14976762

*********STEP 6******
****S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the in the text of Appendix A of the DHS report)*
gen S_h = 20

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

