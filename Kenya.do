**********************************Prepared by Bright Ahinkorah****11/05/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/KE_2022_DHS_08202023_736_129249/KEIR8ADT/KEIR8AFL.DTA"

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
replace A_h = 4031  if v022 == 1 
replace A_h = 365  if v022 == 2 
replace A_h = 1141 if v022 == 4 
replace A_h = 226 if v022 == 6 
replace A_h = 99  if v022 == 8 
replace A_h = 299 if v022 == 10
replace A_h = 441 if v022 == 12
replace A_h = 320 if v022 == 14
replace A_h = 386 if v022 == 16
replace A_h = 215 if v022 == 18 
replace A_h = 273 if v022 == 20 
replace A_h = 492 if v022 == 22
replace A_h = 125 if v022 == 24 
replace A_h = 263 if v022 == 26
replace A_h = 224 if v022 == 28 
replace A_h = 1413 if v022 == 30 
replace A_h = 297 if v022 == 32
replace A_h = 242 if v022 == 34 
replace A_h = 560 if v022 == 36 
replace A_h = 457 if v022 == 38 
replace A_h = 406 if v022 == 40 
replace A_h = 6012 if v022 == 42
replace A_h = 351 if v022 == 44 
replace A_h = 95 if v022 == 46
replace A_h = 138 if v022 == 48
replace A_h = 463 if v022 == 50 
replace A_h = 1863 if v022 == 52 
replace A_h = 74 if v022 == 54
replace A_h = 201 if v022 == 56 
replace A_h = 291 if v022 == 58 
replace A_h = 476 if v022 == 60 
replace A_h = 3431 if v022 == 62 
replace A_h = 375 if v022 == 64
replace A_h = 2272 if v022 == 66 
replace A_h = 336 if v022 == 68
replace A_h = 115 if v022 == 70
replace A_h = 642 if v022 == 72 
replace A_h = 160 if v022 == 74
replace A_h = 557 if v022 == 76 
replace A_h = 336 if v022 == 78 
replace A_h = 280 if v022 == 80 
replace A_h = 1222 if v022 == 82 
replace A_h = 362 if v022 == 84
replace A_h = 461 if v022 == 86
replace A_h = 558 if v022 == 88
replace A_h = 157 if v022 == 90
replace A_h = 15621 if v022 == 92
*Rural
replace A_h = 1462  if v022 == 3 
replace A_h = 1971  if v022 == 5 
replace A_h = 607 if v022 == 7 
replace A_h = 250 if v022 == 9 
replace A_h = 710  if v022 == 11 
replace A_h = 871 if v022 == 13 
replace A_h = 977 if v022 == 15
replace A_h = 901 if v022 == 17
replace A_h = 651 if v022 == 19
replace A_h = 232 if v022 == 21 
replace A_h = 3771 if v022 == 23 
replace A_h = 1109 if v022 == 25 
replace A_h = 1555 if v022 == 27 
replace A_h = 3507 if v022 == 29 
replace A_h = 2720 if v022 == 31 
replace A_h = 2481 if v022 == 33 
replace A_h = 1637 if v022 == 35 
replace A_h = 1960 if v022 == 37 
replace A_h = 1490 if v022 == 39 
replace A_h = 2793 if v022 == 41 
replace A_h = 2085 if v022 == 43 
replace A_h = 1343 if v022 == 45 
replace A_h = 1486 if v022 == 47 
replace A_h = 559 if v022 == 49
replace A_h = 1770 if v022 == 51
replace A_h = 1492 if v022 == 53 
replace A_h = 1089 if v022 == 55 
replace A_h = 1893 if v022 == 57 
replace A_h = 1606 if v022 == 59 
replace A_h = 1076 if v022 == 61 
replace A_h = 2703 if v022 == 63 
replace A_h = 2245 if v022 == 65 
replace A_h = 1094 if v022 == 67
replace A_h = 1829 if v022 == 69 
replace A_h = 1818 if v022 == 71 
replace A_h = 3963 if v022 == 73
replace A_h = 1241 if v022 == 75 
replace A_h = 3175 if v022 == 77
replace A_h = 1727 if v022 == 79 
replace A_h = 2396 if v022 == 81 
replace A_h = 1711 if v022 == 83 
replace A_h = 2526 if v022 == 85 
replace A_h = 2124 if v022 == 87
replace A_h = 2968 if v022 == 89
replace A_h = 1541 if v022 == 91
*********STEP 3******
* M_h average number of households per cluster by strata (Table A.2 of the DHS report) 
gen M_h = 0 
*Urban
replace M_h = 220 if v022 == 1
replace M_h = 84 if v022 == 2
replace M_h = 100 if v022 == 4
replace M_h = 96 if v022 == 6 
replace M_h = 88 if v022 == 8 
replace M_h = 88 if v022 == 10 
replace M_h = 92 if v022 == 12 
replace M_h = 92 if v022 == 14 
replace M_h = 96 if v022 == 16 
replace M_h = 88 if v022 == 18 
replace M_h = 104 if v022 == 20
replace M_h = 80 if v022 == 22
replace M_h = 68 if v022 == 24 
replace M_h = 72 if v022 == 26 
replace M_h = 68 if v022 == 28 
replace M_h = 96 if v022 == 30 
replace M_h = 72 if v022 == 32 
replace M_h = 72 if v022 == 34
replace M_h = 84 if v022 == 36
replace M_h = 88 if v022 == 38 
replace M_h = 76 if v022 == 40 
replace M_h = 140 if v022 == 42
replace M_h = 80 if v022 == 44
replace M_h = 68 if v022 == 46 
replace M_h = 80 if v022 == 48 
replace M_h = 84 if v022 == 50 
replace M_h = 120 if v022 == 52
replace M_h = 60 if v022 == 54
replace M_h = 68 if v022 == 56 
replace M_h = 80 if v022 == 58
replace M_h = 92 if v022 == 60 
replace M_h = 120 if v022 == 62
replace M_h = 72 if v022 == 64
replace M_h = 108 if v022 == 66 
replace M_h = 76 if v022 == 68
replace M_h = 60 if v022 == 70 
replace M_h = 76 if v022 == 72
replace M_h = 68 if v022 == 74
replace M_h = 76 if v022 == 76
replace M_h = 80 if v022 == 78
replace M_h = 72 if v022 == 80
replace M_h = 104 if v022 == 82
replace M_h = 72 if v022 == 84
replace M_h = 80 if v022 == 86
replace M_h = 84 if v022 == 88
replace M_h = 68 if v022 == 90
replace M_h = 300 if v022 == 92
*Rural
replace M_h = 124  if v022 == 3 
replace M_h = 108  if v022 == 5 
replace M_h = 124 if v022 == 7 
replace M_h = 120 if v022 == 9 
replace M_h = 112  if v022 == 11 
replace M_h = 128 if v022 == 13 
replace M_h = 128 if v022 == 15
replace M_h = 124 if v022 == 17
replace M_h = 120 if v022 == 19
replace M_h = 104 if v022 == 21 
replace M_h = 148 if v022 == 23 
replace M_h = 132 if v022 == 25 
replace M_h = 128 if v022 == 27 
replace M_h = 140 if v022 == 29  
replace M_h = 112 if v022 == 31 
replace M_h = 136 if v022 == 33 
replace M_h = 128 if v022 == 35 
replace M_h = 124 if v022 == 37 
replace M_h = 120 if v022 == 39 
replace M_h = 132 if v022 == 41 
replace M_h = 100 if v022 == 43
replace M_h = 128 if v022 == 45 
replace M_h = 140 if v022 == 47 
replace M_h = 120 if v022 == 49 
replace M_h = 124 if v022 == 51 
replace M_h = 112 if v022 == 53 
replace M_h = 140 if v022 == 55 
replace M_h = 140 if v022 == 57 
replace M_h = 132 if v022 == 59
replace M_h = 116 if v022 == 61 
replace M_h = 116 if v022 == 63 
replace M_h = 128 if v022 == 65
replace M_h = 92 if v022 == 67
replace M_h = 132 if v022 == 69
replace M_h = 148 if v022 == 71 
replace M_h = 136 if v022 == 73 
replace M_h = 132 if v022 == 75 
replace M_h = 136 if v022 == 77 
replace M_h = 128 if v022 == 79
replace M_h = 136 if v022 == 81
replace M_h = 116 if v022 == 83 
replace M_h = 136 if v022 == 85 
replace M_h = 128 if v022 == 87 
replace M_h = 140 if v022 == 89 
replace M_h = 140 if v022 == 91
*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 37911 
*********STEP 5****** 
* M total number of households in country (Table A.1 of the DHS report) 
gen M = 12040701  
*********STEP 6******
**S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the text of Appendix A of the DHS report)*
gen S_h = 25
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




























