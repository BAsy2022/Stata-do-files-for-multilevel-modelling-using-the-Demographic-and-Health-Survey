**********************************Prepared by Bright Ahinkorah****24/04/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/TD_2014-15_DHS_01272019_192_129249/TDIR71DT/TDIR71FL.DTA", replace

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
replace A_h = 49  if v022 == 1
replace A_h = 29  if v022 == 3
replace A_h = 24  if v022 == 5
replace A_h = 83  if v022 == 7
replace A_h = 62  if v022 == 9
replace A_h = 46  if v022 == 11
replace A_h = 45 if v022 == 13
replace A_h = 159  if v022 == 15
replace A_h = 107  if v022 == 17
replace A_h = 55  if v022 == 19
replace A_h = 95  if v022 == 21
replace A_h = 75  if v022 == 23
replace A_h = 95  if v022 == 25
replace A_h = 95  if v022 == 27
replace A_h = 64  if v022 == 29
replace A_h = 64  if v022 == 31
replace A_h = 36  if v022 == 33
replace A_h = 760  if v022 == 35
replace A_h = 32  if v022 == 36
replace A_h = 16  if v022 == 38
replace A_h = 28  if v022 == 40
*Rural
replace A_h = 436  if v022 == 2
replace A_h = 68  if v022 == 4
replace A_h = 512  if v022 == 6
replace A_h = 445  if v022 == 8
replace A_h = 489 if v022 == 10
replace A_h = 306  if v022 == 12
replace A_h = 381  if v022 == 14
replace A_h = 455 if v022 == 16
replace A_h = 664  if v022 == 18
replace A_h = 576  if v022 == 20
replace A_h = 635  if v022 == 22
replace A_h = 502  if v022 == 24
replace A_h = 426  if v022 == 26
replace A_h = 460  if v022 == 28
replace A_h = 196  if v022 == 30
replace A_h = 622  if v022 == 32
replace A_h = 343  if v022 == 34
replace A_h = 110  if v022 == 37
replace A_h = 105  if v022 == 39
replace A_h = 287  if v022 == 41

*********STEP 3******
* M_h average number of population per cluster by strata (Table A.2 of the DHS report)
gen M_h = 0
*Urban
replace M_h = 181  if v022 == 1
replace M_h = 208  if v022 == 3
replace M_h = 212  if v022 == 5
replace M_h = 190  if v022 == 7
replace M_h = 203  if v022 == 9
replace M_h = 184  if v022 == 11
replace M_h = 181  if v022 == 13
replace M_h = 203  if v022 == 15
replace M_h = 220  if v022 == 17
replace M_h = 217  if v022 == 19
replace M_h = 183  if v022 == 21
replace M_h = 166  if v022 == 23
replace M_h = 234  if v022 == 25
replace M_h = 209  if v022 == 27
replace M_h = 188  if v022 == 29
replace M_h = 222  if v022 == 31
replace M_h = 175  if v022 == 33
replace M_h = 226  if v022 == 35
replace M_h = 155  if v022 == 36
replace M_h = 154  if v022 == 38
replace M_h = 183  if v022 == 40
*Rural
replace M_h = 185 if v022 == 2
replace M_h = 195 if v022 == 4
replace M_h = 184  if v022 == 6
replace M_h = 187  if v022 == 8
replace M_h = 178  if v022 == 10
replace M_h = 200  if v022 == 12
replace M_h = 203  if v022 == 14
replace M_h = 214  if v022 == 16
replace M_h = 177  if v022 == 18
replace M_h = 172  if v022 == 20
replace M_h = 173  if v022 == 22
replace M_h = 148  if v022 == 24
replace M_h = 171  if v022 == 26
replace M_h = 218  if v022 == 28
replace M_h = 203  if v022 == 30
replace M_h = 161  if v022 == 32
replace M_h = 181  if v022 == 34
replace M_h = 163  if v022 == 37
replace M_h = 142  if v022 == 39
replace M_h = 229  if v022 == 41

*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c=  17233   

*********STEP 5******
* M total number of households in country (ChatGPT)
gen M = 1073493 

*********STEP 6******
**S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the in the text of Appendix A of the DHS report)*
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

