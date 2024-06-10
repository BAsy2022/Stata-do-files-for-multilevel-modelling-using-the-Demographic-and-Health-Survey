**********************************Prepared by Bright Ahinkorah****25/03/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/AO_2015-16_DHS_01272019_1843_129249/AOIR71DT/AOIR71FL.DTA"
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
replace A_h = 1190  if v022 == 1
replace A_h = 896  if v022 == 3
replace A_h = 1044  if v022 == 5
replace A_h = 16267  if v022 == 7
replace A_h = 481  if v022 == 9
replace A_h = 1636  if v022 == 11
replace A_h = 995 if v022 == 13
replace A_h = 983  if v022 == 15
replace A_h = 3076  if v022 == 17
replace A_h = 1847  if v022 == 19
replace A_h = 1129  if v022 == 21
replace A_h = 738  if v022 == 23
replace A_h = 707  if v022 == 25
replace A_h = 437  if v022 == 27
replace A_h = 1640  if v022 == 29
replace A_h = 530  if v022 == 31
replace A_h = 738  if v022 == 33
replace A_h = 280  if v022 == 35
*Rural
replace A_h = 492  if v022 == 2
replace A_h = 812  if v022 == 4
replace A_h = 3733  if v022 == 6
replace A_h = 905  if v022 == 8
replace A_h = 900  if v022 == 10
replace A_h = 4551  if v022 == 12
replace A_h = 2618  if v022 == 14
replace A_h = 1264  if v022 == 16
replace A_h = 2629  if v022 == 18
replace A_h = 3821  if v022 == 20
replace A_h = 3266  if v022 == 22
replace A_h = 1458  if v022 == 24
replace A_h = 1162  if v022 == 26
replace A_h = 440  if v022 == 28
replace A_h = 4422  if v022 == 30
replace A_h = 1794  if v022 == 32
replace A_h = 481  if v022 == 34
replace A_h = 781 if v022 == 36

*********STEP 3******
* M_h average number of population per cluster by strata (Table A.2 of the DHS report)
gen M_h = 0
*Urban
replace M_h = 97  if v022 == 1
replace M_h = 101  if v022 == 3
replace M_h = 97  if v022 == 5
replace M_h = 105  if v022 == 7
replace M_h = 110  if v022 == 9
replace M_h = 100  if v022 == 11
replace M_h = 109  if v022 == 13
replace M_h = 109  if v022 == 15
replace M_h = 99  if v022 == 17
replace M_h = 96  if v022 == 19
replace M_h = 102  if v022 == 21
replace M_h = 100  if v022 == 23
replace M_h = 95  if v022 == 25
replace M_h = 104  if v022 == 27
replace M_h = 102  if v022 == 29
replace M_h = 98  if v022 == 31
replace M_h = 101  if v022 == 33
replace M_h = 106  if v022 == 35
*Rural
replace M_h = 56 if v022 == 2
replace M_h = 41  if v022 == 4
replace M_h = 60  if v022 == 6
replace M_h = 79  if v022 == 8
replace M_h = 51  if v022 == 10
replace M_h = 72  if v022 == 12
replace M_h = 49  if v022 == 14
replace M_h = 55  if v022 == 16
replace M_h = 69  if v022 == 18
replace M_h = 62  if v022 == 20
replace M_h = 58  if v022 == 22
replace M_h = 59  if v022 == 24
replace M_h = 52  if v022 == 26
replace M_h = 63  if v022 == 28
replace M_h = 71 if v022 == 30
replace M_h = 81  if v022 == 32
replace M_h = 58  if v022 == 34
replace M_h = 65  if v022 == 36

*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 16109 
*********STEP 5******
* M total number of households in country (Table A.1 of the DHS report)
gen M = 5800015
*********STEP 6******
*** S_h households selected per stratum (AAdd the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)
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



























