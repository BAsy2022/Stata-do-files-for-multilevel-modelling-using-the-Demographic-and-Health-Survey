**********************************Prepared by Bright Ahinkorah****25/03/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/GH_2022_DHS_01182024_2015_129249/GHIR8ADT/GHIR8AFL.DTA"

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
* A_h total number of census clusters by strata (Table A.3 of the DHS report)
gen A_h = 0
*urban
replace A_h = 1603  if v022 == 1
replace A_h = 2255  if v022 == 3
replace A_h = 6352  if v022 == 5
replace A_h = 1016  if v022 == 7
replace A_h = 2148  if v022 == 9
replace A_h = 6157  if v022 == 11
replace A_h = 392 if v022 == 13
replace A_h = 461  if v022 == 15
replace A_h = 1094  if v022 == 17
replace A_h = 969  if v022 == 19
replace A_h = 401  if v022 == 21
replace A_h = 1830  if v022 == 23
replace A_h = 285  if v022 == 25
replace A_h = 365  if v022 == 27
replace A_h = 557  if v022 == 29
replace A_h = 410  if v022 == 31
*Rural
replace A_h = 1555  if v022 == 2
replace A_h = 2023  if v022 == 4
replace A_h = 597  if v022 == 6
replace A_h = 1885  if v022 == 8
replace A_h = 2773  if v022 == 10
replace A_h = 4126  if v022 == 12
replace A_h = 1231  if v022 == 14
replace A_h = 707  if v022 == 16
replace A_h = 955  if v022 == 18
replace A_h = 1192  if v022 == 20
replace A_h = 1105  if v022 == 22
replace A_h = 2402  if v022 == 24
replace A_h = 852  if v022 == 26
replace A_h = 848  if v022 == 28
replace A_h = 1936  if v022 == 30
replace A_h = 1435  if v022 == 32

*********STEP 3******
* M_h average number of population per cluster by strata (Table A.3 of the DHS report)
gen M_h = 0
*Urban
replace M_h = 205  if v022 == 1
replace M_h = 219  if v022 == 3
replace M_h = 249  if v022 == 5
replace M_h = 210  if v022 == 7
replace M_h = 218  if v022 == 9
replace M_h = 155  if v022 == 11
replace M_h = 197  if v022 == 13
replace M_h = 172  if v022 == 15
replace M_h = 181  if v022 == 17
replace M_h = 171  if v022 == 19
replace M_h = 153  if v022 == 21
replace M_h = 129  if v022 == 23
replace M_h = 153  if v022 == 25
replace M_h = 105  if v022 == 27
replace M_h = 135  if v022 == 29
replace M_h = 149  if v022 == 31
*Rural
replace M_h = 188 if v022 == 2
replace M_h = 170  if v022 == 4
replace M_h = 206  if v022 == 6
replace M_h = 147  if v022 == 8
replace M_h = 149  if v022 == 10
replace M_h = 137  if v022 == 12
replace M_h = 132  if v022 == 14
replace M_h = 104  if v022 == 16
replace M_h = 126  if v022 == 18
replace M_h = 103  if v022 == 20
replace M_h = 102  if v022 == 22
replace M_h = 84  if v022 == 24
replace M_h = 105  if v022 == 26
replace M_h = 82  if v022 == 28
replace M_h = 98  if v022 == 30
replace M_h = 90  if v022 == 32

*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 17933 

*********STEP 5******
* M total number of households in country (Table A.2 of the DHS report)
gen M = 8365174

*********STEP 6******
**S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)*
gen S_h = 30 

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
**Calculate level-weights based on the following 8 scenarios of α: 0.05, 0, 0.1, .25, .50, .75, 0.90 and 1.
local alphas 0.05 0 0.1 .25 .50 .75 0.90 1
local i = 1 
foreach dom of local alphas {  
	gen wt2_`i' = (A_h/a_c_h)*(f^`dom') 
	gen wt1_`i' = d_HH/wt2_`i' 
	local ++i 
} 
****************** Stage 4 *** Svyset *** ********
svyset v001, weight(wt2_1) strata(v022) , singleunit(centered) || _n, weight(wt1_1) 


























