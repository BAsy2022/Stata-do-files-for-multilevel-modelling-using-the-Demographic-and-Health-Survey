**********************************Prepared by Bright Ahinkorah****25/03/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/MD_2021_DHS_11262023_215_129249/MDIR81DT/MDIR81FL.DTA"

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
replace A_h = 974  if v022 == 1 
replace A_h = 878  if v022 == 3 
replace A_h = 96 if v022 == 4 
replace A_h = 235 if v022 == 6 
replace A_h = 155  if v022 == 8 
replace A_h = 36 if v022 == 10 
replace A_h = 213 if v022 == 12 
replace A_h = 99 if v022 == 14 
replace A_h = 127 if v022 == 16 
replace A_h = 29 if v022 == 18 
replace A_h = 92 if v022 == 20 
replace A_h = 275 if v022 == 22 
replace A_h = 206 if v022 == 24 
replace A_h = 147 if v022 == 26 
replace A_h = 248 if v022 == 28 
replace A_h = 155 if v022 == 30 
replace A_h = 51 if v022 == 32 
replace A_h = 30 if v022 == 34 
replace A_h = 235 if v022 == 36
replace A_h = 119  if v022 == 38 
replace A_h = 130  if v022 == 40 
replace A_h = 98 if v022 == 42 
replace A_h = 244 if v022 == 44 
replace A_h = 169  if v022 == 46 
*Rural
replace A_h = 1917 if v022 == 2
replace A_h = 1917 if v022 == 5
replace A_h = 1873 if v022 == 7 
replace A_h = 907 if v022 == 9 
replace A_h = 731 if v022 == 11 
replace A_h = 1475 if v022 == 13
replace A_h = 864 if v022 == 15
replace A_h = 2060 if v022 == 17 
replace A_h = 649 if v022 == 19
replace A_h = 1900 if v022 == 21 
replace A_h = 1473 if v022 == 23 
replace A_h = 1322 if v022 == 25 
replace A_h = 1220 if v022 == 27 
replace A_h = 863 if v022 == 29
replace A_h = 1679  if v022 == 31 
replace A_h = 472  if v022 == 33
replace A_h = 445 if v022 == 35
replace A_h = 2206 if v022 == 37 
replace A_h = 1273  if v022 == 39 
replace A_h = 1058 if v022 == 41
replace A_h = 880 if v022 == 43
replace A_h = 688 if v022 == 45
replace A_h = 1164 if v022 == 47 

*********STEP 3******
* M_h average number of households per cluster by strata (Table A.3 of the DHS report) 
gen M_h = 0 
*Urban
replace M_h = 361  if v022 == 1 
replace M_h = 373  if v022 == 3 
replace M_h = 252 if v022 == 4 
replace M_h = 345 if v022 == 6 
replace M_h = 242 if v022 == 8 
replace M_h = 323 if v022 == 10 
replace M_h = 287 if v022 == 12
replace M_h = 264 if v022 == 14
replace M_h = 249 if v022 == 16
replace M_h = 313 if v022 == 18 
replace M_h = 184 if v022 == 20 
replace M_h = 407 if v022 == 22 
replace M_h = 272 if v022 == 24 
replace M_h = 304 if v022 == 26 
replace M_h = 362 if v022 == 28 
replace M_h = 316 if v022 == 30 
replace M_h = 229 if v022 == 32 
replace M_h = 281 if v022 == 34 
replace M_h = 258 if v022 == 36
replace M_h = 163  if v022 == 38 
replace M_h = 241  if v022 == 40 
replace M_h = 274 if v022 == 42 
replace M_h = 457 if v022 == 44 
replace M_h = 364  if v022 == 46
*Rural 
replace M_h = 287 if v022 == 2
replace M_h = 287 if v022 == 5
replace M_h = 206 if v022 == 7 
replace M_h = 185 if v022 == 9 
replace M_h = 192 if v022 == 11 
replace M_h = 161 if v022 == 13
replace M_h = 171 if v022 == 15
replace M_h = 137 if v022 == 17 
replace M_h = 128 if v022 == 19 
replace M_h = 95 if v022 == 21
replace M_h = 181 if v022 == 23 
replace M_h = 203 if v022 == 25 
replace M_h = 208 if v022 == 27 
replace M_h = 164 if v022 == 29
replace M_h = 194  if v022 == 31 
replace M_h = 167  if v022 == 33 
replace M_h = 139 if v022 == 35
replace M_h = 162 if v022 == 37 
replace M_h = 143  if v022 == 39 
replace M_h = 152 if v022 == 41 
replace M_h = 156 if v022 == 43
replace M_h = 213 if v022 == 45
replace M_h = 216 if v022 == 47 
 *********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 20510 
*********STEP 5******
* M total number of households in country (Table A.2 of the DHS report) 
gen M = 6115308 
*********STEP 6******
**S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)*
* S_h households selected per stratum 
gen S_h = 45 

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




























