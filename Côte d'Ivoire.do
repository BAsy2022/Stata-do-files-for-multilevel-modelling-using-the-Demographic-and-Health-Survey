**********************************Prepared by Bright Ahinkorah****11/05/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/CI_2021_DHS_11262023_210_129249/CIIR81DT/CIIR81FL.DTA", replace

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
replace A_h = 5883  if v022 == 1
replace A_h = 260  if v022 == 3
replace A_h = 807  if v022 == 5
replace A_h = 554  if v022 == 7
replace A_h = 126  if v022 == 9
replace A_h = 804  if v022 == 11
replace A_h = 467  if v022 == 13
replace A_h = 814  if v022 == 15
replace A_h = 1010 if v022 == 17
replace A_h = 1040  if v022 == 19
replace A_h = 873  if v022 == 21
replace A_h = 930 if v022 == 23
replace A_h = 258  if v022 == 25
replace A_h = 277  if v022 == 27
*Rural
replace A_h = 165 if v022 == 2
replace A_h = 125  if v022 == 4
replace A_h = 1856  if v022 == 6
replace A_h = 849 if v022 == 8
replace A_h = 274 if v022 == 10
replace A_h = 1225 if v022 == 12
replace A_h = 1031  if v022 == 14
replace A_h = 1076  if v022 == 16
replace A_h = 1926  if v022 == 18
replace A_h = 1642  if v022 == 20
replace A_h = 1225  if v022 == 22
replace A_h = 1006  if v022 == 24
replace A_h = 871  if v022 == 26
replace A_h = 972  if v022 == 28
*********STEP 3******
* M_h average number of population per cluster by strata (Table A.2 of the DHS report)
gen M_h = 0
*Urban
replace M_h = 1120  if v022 == 1
replace M_h = 1030 if v022 == 3
replace M_h = 1098  if v022 == 5
replace M_h = 1033 if v022 == 7
replace M_h = 1024  if v022 == 9
replace M_h = 1109  if v022 == 11
replace M_h = 1076  if v022 == 13
replace M_h = 1056 if v022 == 15
replace M_h = 1047  if v022 == 17
replace M_h = 1078  if v022 == 19
replace M_h = 995 if v022 == 21
replace M_h = 1070  if v022 == 23
replace M_h = 1068  if v022 == 25
replace M_h = 1066 if v022 == 27
*Rural
replace M_h = 1039  if v022 == 2
replace M_h = 1013  if v022 == 4
replace M_h = 985  if v022 == 6
replace M_h = 974  if v022 == 8
replace M_h = 952  if v022 == 10
replace M_h = 987  if v022 == 12
replace M_h = 949 if v022 == 14
replace M_h = 973 if v022 == 16
replace M_h = 974 if v022 == 18
replace M_h = 952 if v022 == 20
replace M_h = 936 if v022 == 22
replace M_h = 969 if v022 == 24
replace M_h = 949 if v022 == 26
replace M_h = 984 if v022 == 28

*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c=  14766    

*********STEP 5******
* M total number of households in country (ChatGPT)
gen M = 2300000 

*********STEP 6******
**S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)*
gen S_h = 28

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

