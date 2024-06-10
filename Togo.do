**********************************Prepared by Bright Ahinkorah****31/05/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/TG_2013-14_DHS_01272019_1931_129249/TGIR61DT/TGIR61FL.DTA"


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
replace A_h = 871  if v022 == 1
replace A_h = 821  if v022 == 2
replace A_h = 261  if v022 == 4
replace A_h = 125  if v022 == 6
replace A_h = 169  if v022 == 8
replace A_h = 109  if v022 == 10
*rural
replace A_h = 1148  if v022 == 3
replace A_h = 1264 if v022 == 5
replace A_h = 563  if v022 == 7
replace A_h = 670  if v022 == 9
replace A_h = 720 if v022 == 11


*********STEP 3******
* M_h average number of population per cluster by strata (Table A.2 of the DHS report)
gen M_h = 0
*urban
replace M_h = 224  if v022 == 1
replace M_h = 210  if v022 == 2
replace M_h = 246  if v022 == 4
replace M_h = 228  if v022 == 6
replace M_h = 253  if v022 == 8
replace M_h = 198  if v022 == 10
*rural
replace M_h = 174  if v022 == 3
replace M_h = 169 if v022 == 5
replace M_h = 138  if v022 == 7
replace M_h = 148  if v022 == 9
replace M_h = 128 if v022 == 11


*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 9549  

*********STEP 5******
* M total number of households in country (ChatGPT)
gen M = 1318000

*********STEP 6******
****S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the in the text of Appendix A of the DHS report)*
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

