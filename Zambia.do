**********************************Prepared by Bright Ahinkorah****31/05/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/ZM_2018_DHS_05012020_1241_129249/ZMIR71DT/ZMIR71FL.DTA"


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
*urban
replace A_h = 593  if v022 == 1
replace A_h = 2351  if v022 == 3
replace A_h = 245  if v022 == 5
replace A_h = 334  if v022 == 7
replace A_h = 2767  if v022 == 9
replace A_h = 188  if v022 == 11
replace A_h = 297  if v022 == 13
replace A_h = 198  if v022 == 15
replace A_h = 541  if v022 == 17
replace A_h = 214  if v022 == 19
*rural
replace A_h = 2234  if v022 == 2
replace A_h = 924  if v022 == 4
replace A_h = 3279 if v022 == 6
replace A_h = 1890  if v022 == 8
replace A_h = 833 if v022 == 10
replace A_h = 1470  if v022 == 12
replace A_h = 2207  if v022 == 14
replace A_h = 984 if v022 == 16
replace A_h = 2307  if v022 == 18
replace A_h = 1775  if v022 == 20



*********STEP 3******
* M_h average number of population per cluster by strata (Table A.2 of the DHS report)
gen M_h = 0
*urban
replace M_h = 128  if v022 == 1
replace M_h = 89  if v022 == 3
replace M_h = 143 if v022 == 5
replace M_h = 98 if v022 == 7
replace M_h = 193  if v022 == 9
replace M_h = 90  if v022 == 11
replace M_h = 132  if v022 == 13
replace M_h = 106  if v022 == 15
replace M_h = 153  if v022 == 17
replace M_h = 111  if v022 == 19
*rural
replace M_h = 141  if v022 == 2
replace M_h = 87  if v022 == 4
replace M_h = 149  if v022 == 6
replace M_h = 89  if v022 == 8
replace M_h = 159  if v022 == 10
replace M_h = 112  if v022 == 12
replace M_h = 147  if v022 == 14
replace M_h = 90  if v022 == 16
replace M_h = 127  if v022 == 18
replace M_h = 92  if v022 == 20


*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 12831  

*********STEP 5******
* M total number of households in country (Table A.1 of the DHS report)
gen M = 2815897

*********STEP 6******
****S_h households selected per stratum (S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)*
gen S_h = 25

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

