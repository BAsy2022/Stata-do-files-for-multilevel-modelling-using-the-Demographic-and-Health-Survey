**********************************Prepared by Bright Ahinkorah****25/03/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/MW_2015-16_DHS_01272019_1918_129249/MWIR7HDT/MWIR7HFL.DTA"

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
* A_h total number of census clusters by strata (Table B.2 of the DHS report)
gen A_h = 0
*Urban
replace A_h = 11  if v022 == 1 
replace A_h = 37  if v022 == 3 
replace A_h = 12 if v022 == 5 
replace A_h = 12 if v022 == 7 
replace A_h = 122  if v022 == 9 
replace A_h = 2 if v022 == 11 
replace A_h = 29 if v022 == 13 
replace A_h = 16 if v022 == 15 
replace A_h = 6 if v022 == 17 
replace A_h = 18 if v022 == 19 
replace A_h = 22 if v022 == 21 
replace A_h = 12 if v022 == 23 
replace A_h = 15 if v022 == 25 
replace A_h = 11 if v022 == 27 
replace A_h = 458 if v022 == 29 
replace A_h = 25 if v022 == 31
replace A_h = 19 if v022 == 33 
replace A_h = 2 if v022 == 35 
replace A_h = 9 if v022 == 37
replace A_h = 12  if v022 == 39
replace A_h = 17  if v022 == 41
replace A_h = 3 if v022 == 43 
replace A_h = 16 if v022 == 45 
replace A_h = 14  if v022 == 47 
replace A_h = 17 if v022 == 49
replace A_h = 3 if v022 == 51
replace A_h = 79 if v022 == 53 
replace A_h = 412 if v022 == 55
*Rural
replace A_h = 205 if v022 == 2 
replace A_h = 370 if v022 == 4
replace A_h = 229 if v022 == 6
replace A_h = 156 if v022 == 8 
replace A_h = 825 if v022 == 10 
replace A_h = 9 if v022 == 12 
replace A_h = 486 if v022 == 14 
replace A_h = 177 if v022 == 16 
replace A_h = 204 if v022 == 18 
replace A_h = 450 if v022 == 20
replace A_h = 416 if v022 == 22
replace A_h = 374  if v022 == 24 
replace A_h = 486  if v022 == 26 
replace A_h = 468 if v022 == 28
replace A_h = 1173 if v022 == 30 
replace A_h = 614  if v022 == 32 
replace A_h = 436 if v022 == 34
replace A_h = 334 if v022 == 36
replace A_h = 80 if v022 == 38
replace A_h = 674 if v022 == 40
replace A_h = 658 if v022 == 42
replace A_h = 316 if v022 == 44
replace A_h = 380 if v022 == 46
replace A_h = 241 if v022 == 48
replace A_h = 275 if v022 == 50
replace A_h = 157 if v022 == 52
replace A_h = 484 if v022 == 54
replace A_h = 381 if v022 == 56 

*********STEP 3******
* M_h average number of households per cluster by strata (Table B.2 of the DHS report) 
gen M_h = 0
*Urban 
replace M_h = 266  if v022 == 1 
replace M_h = 232  if v022 == 3 
replace M_h = 190 if v022 == 5 
replace M_h = 321 if v022 == 7 
replace M_h = 255 if v022 == 9 
replace M_h = 150 if v022 == 11 
replace M_h = 309 if v022 == 13 
replace M_h = 313 if v022 == 15 
replace M_h = 259 if v022 == 17
replace M_h = 249 if v022 == 19 
replace M_h = 277 if v022 == 21 
replace M_h = 298 if v022 == 23 
replace M_h = 299 if v022 == 25 
replace M_h = 301 if v022 == 27 
replace M_h = 336 if v022 == 29 
replace M_h = 339 if v022 == 31 
replace M_h = 279 if v022 == 33 
replace M_h = 296 if v022 == 35 
replace M_h = 383 if v022 == 37
replace M_h = 200  if v022 == 39 
replace M_h = 191  if v022 == 41 
replace M_h = 372 if v022 == 43
replace M_h = 177 if v022 == 45
replace M_h = 302  if v022 == 47 
replace M_h = 296 if v022 == 49
replace M_h = 122 if v022 == 51
replace M_h = 241 if v022 == 53 
replace M_h = 373 if v022 == 55 
*Rural
replace M_h = 170 if v022 == 2 
replace M_h = 133 if v022 == 4
replace M_h = 175 if v022 == 6
replace M_h = 206 if v022 == 8 
replace M_h = 168 if v022 == 10 
replace M_h = 191 if v022 == 12 
replace M_h = 243 if v022 == 14 
replace M_h = 325 if v022 == 16 
replace M_h = 225 if v022 == 18 
replace M_h = 261 if v022 == 20
replace M_h = 172  if v022 == 22 
replace M_h = 250  if v022 == 24 
replace M_h = 291 if v022 == 26
replace M_h = 236 if v022 == 28 
replace M_h = 235  if v022 == 30 
replace M_h = 289 if v022 == 32
replace M_h = 252 if v022 == 34
replace M_h = 212 if v022 == 36
replace M_h = 232 if v022 == 38
replace M_h = 207 if v022 == 40
replace M_h = 189 if v022 == 42 
replace M_h = 239 if v022 == 44
replace M_h = 251 if v022 == 46
replace M_h = 201 if v022 == 48 
replace M_h = 257 if v022 == 50
replace M_h = 160 if v022 == 52
replace M_h = 244 if v022 == 54 
replace M_h = 212 if v022 == 56       
*********STEP 4****** 
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 26361 
*********STEP 5******  
* M total number of households in country (Table B.1 of the DHS report) 
gen M = 2956479
*********STEP 6******
**S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)*
gen S_h = 31 
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




























