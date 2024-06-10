**********************************Prepared by Bright Ahinkorah****25/03/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/LB_2019-20_DHS_07032021_737_129249/LBIR7ADT/LBIR7AFL.DTA"

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
replace A_h = 46  if v022 == 1 
replace A_h = 21  if v022 == 3 
replace A_h = 17 if v022 == 5 
replace A_h = 152 if v022 == 7 
replace A_h = 168  if v022 == 9 
replace A_h = 2101 if v022 == 11 
replace A_h = 326 if v022 == 13 
replace A_h = 170 if v022 == 15
replace A_h = 434 if v022 == 17
replace A_h = 83 if v022 == 19 
replace A_h = 5 if v022 == 21 
replace A_h = 23 if v022 == 23 
replace A_h = 7 if v022 == 25
replace A_h = 73 if v022 == 27 
replace A_h = 29 if v022 == 29
*Rural
replace A_h = 227 if v022 == 2 
replace A_h = 127 if v022 == 4 
replace A_h = 261 if v022 == 6 
replace A_h = 316 if v022 == 8
replace A_h = 263 if v022 == 10
replace A_h = 149 if v022 == 12 
replace A_h = 601 if v022 == 14 
replace A_h = 331 if v022 == 16 
replace A_h = 347 if v022 == 18 
replace A_h = 93 if v022 == 20
replace A_h = 147 if v022 == 22 
replace A_h = 195 if v022 == 24 
replace A_h = 123 if v022 == 26 
replace A_h = 98 if v022 == 28
replace A_h = 79 if v022 == 30    
*********STEP 3******
* M_h average number of households per cluster by strata (Table A.2 of the DHS report) 
gen M_h = 0
*Urban 
replace M_h = 77  if v022 == 1 
replace M_h = 107  if v022 == 3 
replace M_h = 90 if v022 == 5 
replace M_h = 97 if v022 == 7 
replace M_h = 125  if v022 == 9 
replace M_h = 104 if v022 == 11
replace M_h = 80 if v022 == 13 
replace M_h = 106 if v022 == 15 
replace M_h = 110 if v022 == 17
replace M_h = 97 if v022 == 19
replace M_h = 97 if v022 == 21 
replace M_h = 113 if v022 == 23 
replace M_h = 72 if v022 == 25
replace M_h = 129 if v022 == 27 
replace M_h = 99 if v022 == 29 
*Rural
replace M_h = 75 if v022 == 2 
replace M_h = 97 if v022 == 4 
replace M_h = 86 if v022 == 6 
replace M_h = 103 if v022 == 8
replace M_h = 92 if v022 == 10
replace M_h = 101 if v022 == 12
replace M_h = 73 if v022 == 14
replace M_h = 95 if v022 == 16
replace M_h = 95 if v022 == 18
replace M_h = 108 if v022 == 20
replace M_h = 92 if v022 == 22
replace M_h = 68 if v022 == 24
replace M_h = 69 if v022 == 26
replace M_h = 101 if v022 == 28
replace M_h = 88 if v022 == 30 
*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 9068
*********STEP 5****** 
* M total number of households in country (Table A.1 of the DHS report) 
gen M = 670727
*********STEP 6****** 
**S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)*
gen S_h = 30
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




























