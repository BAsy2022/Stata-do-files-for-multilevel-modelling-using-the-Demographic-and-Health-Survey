**********************************Prepared by Bright Ahinkorah****24/04/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/CG_2011-12_DHS_01272019_195_129249/CGIR60DT/CGIR60FL.DTA", replace

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
replace A_h = 130  if v022 == 3
replace A_h = 67  if v022 == 8
replace A_h = 30  if v022 == 19
replace A_h = 1335  if v022 == 24
replace A_h = 696  if v022 == 25
*Semi-urban
replace A_h = 12  if v022 == 1
replace A_h = 20  if v022 == 4
replace A_h = 34  if v022 == 6
replace A_h = 92 if v022 == 9
replace A_h = 36  if v022 == 11
replace A_h = 58  if v022 == 13
replace A_h = 91 if v022 == 15
replace A_h = 33  if v022 == 17
replace A_h = 33  if v022 == 20
replace A_h = 51 if v022 == 22
*Rural
replace A_h = 126  if v022 == 2
replace A_h = 159  if v022 == 5
replace A_h = 95 if v022 == 7
replace A_h = 207 if v022 == 10
replace A_h = 276 if v022 == 12
replace A_h = 183  if v022 == 14
replace A_h = 135  if v022 == 16
replace A_h = 89  if v022 == 18
replace A_h = 56  if v022 == 21
replace A_h = 99  if v022 == 23

*********STEP 3******
* M_h average number of population per cluster by strata (Table A.2 of the DHS report)
gen M_h = 0
*Urban
replace M_h = 177  if v022 == 3
replace M_h = 253 if v022 == 8
replace M_h = 214  if v022 == 19
replace M_h = 246 if v022 == 24
replace M_h = 248  if v022 == 25
*Semi-urban
replace M_h = 237  if v022 == 1
replace M_h = 247 if v022 == 4
replace M_h = 214  if v022 == 6
replace M_h = 244  if v022 == 9
replace M_h = 271  if v022 == 11
replace M_h = 215  if v022 == 13
replace M_h = 211  if v022 == 15
replace M_h = 143  if v022 == 17
replace M_h = 153  if v022 == 20
replace M_h = 258  if v022 == 22
*Rural
replace M_h = 181 if v022 == 2
replace M_h = 162  if v022 == 5
replace M_h = 148  if v022 == 7
replace M_h = 174  if v022 == 10
replace M_h = 207 if v022 == 12
replace M_h = 146 if v022 == 14
replace M_h = 122 if v022 == 16
replace M_h = 121 if v022 == 18
replace M_h = 132 if v022 == 21
replace M_h = 187 if v022 == 23

*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c=  11632    

*********STEP 5******
* M total number of households in country (ChatGPT)
gen M = 804000   

*********STEP 6******
**S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)*
gen S_h = 29

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

