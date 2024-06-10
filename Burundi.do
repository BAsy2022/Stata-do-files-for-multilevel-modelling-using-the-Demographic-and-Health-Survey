**********************************Prepared by Bright Ahinkorah****23/04/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/BU_2016-17_DHS_01272019_190_129249/BUIR70DT/BUIR70FL.DTA"
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
replace A_h = 16  if v022 == 1
replace A_h = 17  if v022 == 3
replace A_h = 6  if v022 == 5
replace A_h = 3  if v022 == 7
replace A_h = 19  if v022 == 9
replace A_h = 35  if v022 == 11
replace A_h = 8 if v022 == 13
replace A_h = 21  if v022 == 15
replace A_h = 13  if v022 == 17
replace A_h = 10  if v022 == 19
replace A_h = 8  if v022 == 21
replace A_h = 9  if v022 == 23
replace A_h = 3  if v022 == 25
replace A_h = 33  if v022 == 27
replace A_h = 8  if v022 == 29
replace A_h = 6  if v022 == 31
replace A_h = 463  if v022 == 33
replace A_h = 24  if v022 == 34
*Rural
replace A_h = 305  if v022 == 2
replace A_h = 450  if v022 == 4
replace A_h = 328  if v022 == 6
replace A_h = 231  if v022 == 8
replace A_h = 431  if v022 == 10
replace A_h = 692  if v022 == 12
replace A_h = 433  if v022 == 14
replace A_h = 623  if v022 == 16
replace A_h = 626  if v022 == 18
replace A_h = 407  if v022 == 20
replace A_h = 299  if v022 == 22
replace A_h = 604  if v022 == 24
replace A_h = 281  if v022 == 26
replace A_h = 661  if v022 == 28
replace A_h = 334  if v022 == 30
replace A_h = 398  if v022 == 32
replace A_h = 302  if v022 == 35

*********STEP 3******
* M_h average number of population per cluster by strata (Table A.2 of the DHS report)
gen M_h = 0
*Urban
replace M_h = 266  if v022 == 1
replace M_h = 262  if v022 == 3
replace M_h = 255  if v022 == 5
replace M_h = 225  if v022 == 7
replace M_h = 252  if v022 == 9
replace M_h = 238  if v022 == 11
replace M_h = 258  if v022 == 13
replace M_h = 216  if v022 == 15
replace M_h = 223  if v022 == 17
replace M_h = 305  if v022 == 19
replace M_h = 221  if v022 == 21
replace M_h = 242  if v022 == 23
replace M_h = 222 if v022 == 25
replace M_h = 218  if v022 == 27
replace M_h = 249  if v022 == 29
replace M_h = 287  if v022 == 31
replace M_h = 211  if v022 == 33
replace M_h = 284 if v022 == 34
*Rural
replace M_h = 217 if v022 == 2
replace M_h = 191  if v022 == 4
replace M_h = 178  if v022 == 6
replace M_h = 200  if v022 == 8
replace M_h = 210 if v022 == 10
replace M_h = 210  if v022 == 12
replace M_h = 209  if v022 == 14
replace M_h = 193  if v022 == 16
replace M_h = 231 if v022 == 18
replace M_h = 201  if v022 == 20
replace M_h = 199 if v022 == 22
replace M_h = 232 if v022 == 24
replace M_h = 202 if v022 == 26
replace M_h = 211 if v022 == 28
replace M_h = 201 if v022 == 30
replace M_h = 212 if v022 == 32
replace M_h = 205  if v022 == 35

*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 15977 
*********STEP 5******
* M total number of households in country (Table A.1)
gen M = 1695252
*********STEP 6******
*** S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)
gen S_h = 35 
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



























