**********************************Prepared by Bright Ahinkorah****25/03/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/GA_2019-21_DHS_08202023_735_129249/GAIR71DT/GAIR71FL.DTA"

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
* A_h total number of census clusters by strata (Table A.1 of the DHS report)
gen A_h = 0
*Urban
replace A_h = 1179  if v022 == 1 
replace A_h = 260  if v022 == 2 
replace A_h = 282 if v022 == 3 
replace A_h = 185 if v022 == 5 
replace A_h = 73  if v022 == 7 
replace A_h = 92 if v022 == 9 
replace A_h = 54 if v022 == 11 
replace A_h = 48 if v022 == 13 
replace A_h = 50 if v022 == 15 
replace A_h = 22 if v022 == 17 
replace A_h = 128 if v022 == 19
*Rural
replace A_h = 56 if v022 == 4 
replace A_h = 57 if v022 == 6 
replace A_h = 55 if v022 == 8 
replace A_h = 67 if v022 == 10 
replace A_h = 27 if v022 == 12 
replace A_h = 48 if v022 == 14 
replace A_h = 60 if v022 == 16 
replace A_h = 32 if v022 == 18 
replace A_h = 105 if v022 == 20 

*********STEP 3******
* M_h average number of households per cluster by strata (Table A.1 of the DHS report) 
gen M_h = 0
*Urban 
replace M_h = 158  if v022 == 1 
replace M_h = 133  if v022 == 2 
replace M_h = 150 if v022 == 3 
replace M_h = 180 if v022 == 5 
replace M_h = 149  if v022 == 7 
replace M_h = 152 if v022 == 9
replace M_h = 167 if v022 == 11 
replace M_h = 140 if v022 == 13
replace M_h = 144 if v022 == 15
replace M_h = 141 if v022 == 17 
replace M_h = 185 if v022 == 19
*Rural 
replace M_h = 114 if v022 == 4 
replace M_h = 114 if v022 == 6 
replace M_h = 130 if v022 == 8 
replace M_h = 105 if v022 == 10 
replace M_h = 103 if v022 == 12 
replace M_h = 105 if v022 == 14 
replace M_h = 102 if v022 == 16 
replace M_h = 88 if v022 == 18
replace M_h = 185 if v022 == 20
*********STEP 4******  
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 11781 
*********STEP 5******
* M total number of households in country (Table A.2 of the DHS report) 
gen M = 430730 
*********STEP 6******
**S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)*
gen S_h = 32 
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




























