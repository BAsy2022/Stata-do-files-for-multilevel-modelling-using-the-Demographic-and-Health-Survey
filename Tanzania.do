**********************************Prepared by Bright Ahinkorah****31/05/24
clear
clear matrix
clear mata
set maxvar 32000, permanently
use "/Volumes/BOA/DHS SSA/TZ_2022_DHS_11262023_219_129249/TZIR81DT/TZIR81FL.DTA"


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
replace A_h = 621  if v022 == 1
replace A_h = 909  if v022 == 3
replace A_h = 729  if v022 == 5
replace A_h = 905  if v022 == 7
replace A_h = 1458  if v022 == 9
replace A_h = 911  if v022 == 11
replace A_h = 15287  if v022 == 13
replace A_h = 451  if v022 == 14
replace A_h = 812  if v022 == 16
replace A_h = 694  if v022 == 18
replace A_h = 580 if v022 == 20
replace A_h = 1623  if v022 == 22
replace A_h = 308 if v022 == 24
replace A_h = 1026  if v022 == 26
replace A_h = 815  if v022 == 28
replace A_h = 870  if v022 == 30
replace A_h = 535  if v022 == 32
replace A_h = 733 if v022 == 34
replace A_h = 1715  if v022 == 36
replace A_h = 550  if v022 == 38
replace A_h = 357  if v022 == 40
replace A_h = 367  if v022 == 42
replace A_h = 273  if v022 == 44
replace A_h = 201  if v022 == 46
replace A_h = 619  if v022 == 48
replace A_h = 844  if v022 == 50
replace A_h = 40  if v022 == 52
replace A_h = 22  if v022 == 54
replace A_h = 542  if v022 == 56
replace A_h = 75  if v022 == 58
replace A_h = 88  if v022 == 60
*rural
replace A_h = 4170 if v022 == 2
replace A_h = 2200  if v022 == 4
replace A_h = 2570  if v022 == 6
replace A_h = 3599  if v022 == 8
replace A_h = 3567  if v022 == 10
replace A_h = 1922  if v022 == 12
replace A_h = 2004  if v022 == 15
replace A_h = 2979  if v022 == 17
replace A_h = 2309  if v022 == 19
replace A_h = 1621  if v022 == 21
replace A_h = 2433  if v022 == 23
replace A_h = 2312  if v022 == 25
replace A_h = 4859  if v022 == 27
replace A_h = 2152  if v022 == 29
replace A_h = 3818  if v022 == 31
replace A_h = 2349  if v022 == 33
replace A_h = 6907  if v022 == 35
replace A_h = 3000  if v022 == 37
replace A_h = 2732  if v022 == 39
replace A_h = 2218  if v022 == 41
replace A_h = 1455  if v022 == 43
replace A_h = 778  if v022 == 45
replace A_h = 2373  if v022 == 47
replace A_h = 2842  if v022 == 49
replace A_h = 2325  if v022 == 51
replace A_h = 405  if v022 == 53
replace A_h = 319  if v022 == 55
replace A_h = 693  if v022 == 57
replace A_h = 406  if v022 == 59
replace A_h = 365  if v022 == 61


*********STEP 3******
* M_h average number of population per cluster by strata (Table A.2 of the DHS report)
gen M_h = 0
*urban
replace M_h = 117  if v022 == 1
replace M_h = 135  if v022 == 3
replace M_h = 132  if v022 == 5
replace M_h = 106  if v022 == 7
replace M_h = 103  if v022 == 9
replace M_h = 92  if v022 == 11
replace M_h = 71  if v022 == 13
replace M_h = 97 if v022 == 14
replace M_h = 95  if v022 == 16
replace M_h = 110  if v022 == 18
replace M_h = 105 if v022 == 20
replace M_h = 99  if v022 == 22
replace M_h = 119 if v022 == 24
replace M_h = 61  if v022 == 26
replace M_h = 60  if v022 == 28
replace M_h = 81  if v022 == 30
replace M_h = 106  if v022 == 32
replace M_h = 75 if v022 == 34
replace M_h = 109  if v022 == 36
replace M_h = 109  if v022 == 38
replace M_h = 120  if v022 == 40
replace M_h = 109  if v022 == 42
replace M_h = 74  if v022 == 44
replace M_h = 111  if v022 == 46
replace M_h = 89  if v022 == 48
replace M_h = 61  if v022 == 50
replace M_h = 80  if v022 == 52
replace M_h = 78  if v022 == 54
replace M_h = 95  if v022 == 56
replace M_h = 95  if v022 == 58
replace M_h = 80  if v022 == 60
*rural
replace M_h = 90 if v022 == 2
replace M_h = 107  if v022 == 4
replace M_h = 110  if v022 == 6
replace M_h = 94  if v022 == 8
replace M_h = 98  if v022 == 10
replace M_h = 89  if v022 == 12
replace M_h = 90  if v022 == 15
replace M_h = 89  if v022 == 17
replace M_h = 97  if v022 == 19
replace M_h = 98  if v022 == 21
replace M_h = 99  if v022 == 23
replace M_h = 95 if v022 == 25
replace M_h = 63  if v022 == 27
replace M_h = 69  if v022 == 29
replace M_h = 78  if v022 == 31
replace M_h = 86  if v022 == 33
replace M_h = 67  if v022 == 35
replace M_h = 98  if v022 == 37
replace M_h = 90  if v022 == 39
replace M_h = 103 if v022 == 41
replace M_h = 88  if v022 == 43
replace M_h = 76  if v022 == 45
replace M_h = 87  if v022 == 47
replace M_h = 80  if v022 == 49
replace M_h = 75  if v022 == 51
replace M_h = 82  if v022 == 53
replace M_h = 75  if v022 == 55
replace M_h = 88  if v022 == 57
replace M_h = 79  if v022 == 59
replace M_h = 78  if v022 == 61


*********STEP 4******
* m_c total number of completed households (added from the HR dataset_hv001) 
gen m_c= 15705 

*********STEP 5******
* M total number of households in country (Table A.1 of the DHS report)
gen M = 9198710

*********STEP 6******
****S_h households selected per stratum (Add the number of households selected per cluster. This number can be found in the in the text of Appendix A of the DHS report)*
gen S_h = 26

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

