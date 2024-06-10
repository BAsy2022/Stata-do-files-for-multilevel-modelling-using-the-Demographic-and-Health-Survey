**********************************Prepared by Bright Ahinkorah****25/03/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/RW_2019-20_DHS_11262023_217_129249/RWIR81DT/RWIR81FL.DTA"

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
*Urban
replace A_h = 1454  if v022 == 1 
replace A_h = 278  if v022 == 3 
replace A_h = 398 if v022 == 5 
replace A_h = 188 if v022 == 7 
replace A_h = 236  if v022 == 9
*Rural
replace A_h = 456 if v022 == 2 
replace A_h = 3625 if v022 == 4 
replace A_h = 3442 if v022 == 6 
replace A_h = 2693 if v022 == 8 
replace A_h = 3870 if v022 == 10 

*********STEP 3******
* M_h average number of households per cluster by strata (Table A.3 of the DHS report) 
gen M_h = 0 
*Urban
replace M_h = 153  if v022 == 1 
replace M_h = 187  if v022 == 3 
replace M_h = 171 if v022 == 5
replace M_h = 186 if v022 == 7 
replace M_h = 191  if v022 == 9
*Rural
replace M_h = 151 if v022 == 2 
replace M_h = 151 if v022 == 4 
replace M_h = 139 if v022 == 6 
replace M_h = 133 if v022 == 8 
replace M_h = 143 if v022 == 10 

*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 12949  
*********STEP 5******
* M total number of households in country (Table A.2 of the DHS report) 
gen M = 2425761 
*********STEP 6******
**S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)*
gen S_h = 26 
*********STEP 7******
**Prepare the DHS household weight.** 
gen DHSwt = v005 / 1000000 

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




























