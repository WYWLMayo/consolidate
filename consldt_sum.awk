
function CV(value)
 { sum=""; n=""; mean="";
   _val=substr(value,1,(length(value)-1));
   n=split(_val,val,",") ; 
   if (n <= 1) 
    { sum=val[1]; mean=val[1]; sd="NA"; cv="NA";
    } else { for (i in val)
                {sum=sum+val[i]
                }
                mean=sum/n
                for (i in val)
                {sum_sd=sum_sd+(val[i]-mean)^2
                }
                sd=(sum_sd/(n-1))^0.5
                cv=sd/mean
  ## print "###",  sum, mean, sd, cv ;
           }     
 }

BEGIN {i=0; file_sum=file "_sum.xls"; file_ave=file "_ave.xls";}

### get fields number for necessary information

/Sequence_M/ {	for (fs=1; fs<=NF; fs=fs+1)
		   {if ($fs == "File_Scan") {FScan=fs;}
		    if (($fs == "Sequence") || ($fs == "Annotated Sequence")) {Seq=fs;}
		    if (($fs == "Protein Accessions") || ($fs == "Protein Group Accessions")) {Gi=fs;}
		    if ($fs == "Experiment") {Expt=fs;}
		    if (Label == "SILAC-2")
			{ if ($fs == "Light") {L=fs;}
		    	  if ($fs == "Heavy") {H=fs;}
			}
		    if (Label == "SILAC-3")
			{ if ($fs == "Light") {L=fs;}
			  if ($fs == "Medium") {M=fs;m="yes";}
			  if ($fs == "Heavy") {H=fs;}
			}
		    if (Label == "iTRAQ-4")
			{ if ($fs == "114") {I114=fs;};	if ($fs == "115") {I115=fs;}
			  if ($fs == "116") {I116=fs;};	if ($fs == "117") {I117=fs;}
			}
                    if (Label == "iTRAQ-8")
                        { if ($fs == "114") {I114=fs;}; if ($fs == "115") {I115=fs;};	if ($fs == "116") {I116=fs;}
                          if ($fs == "117") {I117=fs;};	if ($fs == "118") {I118=fs;};	if ($fs == "119") {I119=fs;}
                          if ($fs == "120") {I120=fs;};	if ($fs == "121") {I121=fs;}
			}
                    if (Label == "TMT-6")
			{ if ($fs == "Abundance: 126") {T126=fs;}; 	if ($fs == "Abundance: 127") {T127=fs;};   	if ($fs == "Abundance: 128") {T128=fs;}
                          if ($fs == "Abundance: 129") {T129=fs;};	if ($fs == "Abundance: 130") {T130=fs;};	if ($fs == "Abundance: 131") {T131=fs;}
                        }
                    if (Label == "TMT-10")
                        { if ($fs == "Abundance: 126") {T126=fs;}
                          if ($fs == "Abundance: 127N") {T127N=fs;};	if ($fs == "Abundance: 127C") {T127C=fs;}
                          if ($fs == "Abundance: 128N") {T128N=fs;};	if ($fs == "Abundance: 128C") {T128C=fs;}
                          if ($fs == "Abundance: 129N") {T129N=fs;};	if ($fs == "Abundance: 129C") {T129C=fs;}
                          if ($fs == "Abundance: 130N") {T130N=fs;};	if ($fs == "Abundance: 130C") {T130C=fs;}
                          if ($fs == "Abundance: 131") {T131=fs;}
                        }
                    if (Label == "TMT-Pro")
                        { if ($fs == "Abundance: 126") {T126=fs;}
                          if ($fs == "Abundance: 127N") {T127N=fs;};       if ($fs == "Abundance: 127C") {T127C=fs;}
                          if ($fs == "Abundance: 128N") {T128N=fs;};       if ($fs == "Abundance: 128C") {T128C=fs;}
                          if ($fs == "Abundance: 129N") {T129N=fs;};       if ($fs == "Abundance: 129C") {T129C=fs;}
                          if ($fs == "Abundance: 130N") {T130N=fs;};       if ($fs == "Abundance: 130C") {T130C=fs;}
                          if ($fs == "Abundance: 131N") {T131N=fs;};       if ($fs == "Abundance: 131C") {T131C=fs;}
                          if ($fs == "Abundance: 132N") {T132N=fs;};       if ($fs == "Abundance: 132C") {T132C=fs;}
                          if ($fs == "Abundance: 133N") {T133N=fs;};       if ($fs == "Abundance: 133C") {T133C=fs;}
                          if ($fs == "Abundance: 134N") {T134N=fs;}
                        }

		   } 
	    }

## $0 !~ "Sequence" (creat array for values )
  
		{i=i+1; pep[i]=$1; GI[i]=$4; scan[i]=$FScan; 
 		  split($Expt,CLN,"."); EXPT[i]=CLN[1]; 
 		  if (Label == "SILAC-2") {Light[i]=$L; Heavy[i]=$H;}
		  if (Label == "SILAC-3") {Light[i]=$L; Heavy[i]=$H; Medium[i]=$M;}
		  if (Label == "iTRAQ-4") {I114_[i]=$I114; I115_[i]=$I115; I116_[i]=$I116; I117_[i]=$I117;}
                  if (Label == "iTRAQ-8") {I114_[i]=$I114; I115_[i]=$I115; I116_[i]=$I116; I117_[i]=$I117; I118_[i]=$I118; I119_[i]=$I119; I120_[i]=$I120; I121_[i]=$I121;}
                  if (Label == "TMT-6")   {T126_[i]=$T126; T127_[i]=$T127; T128_[i]=$T128; T129_[i]=$T129; T130_[i]=$T130; T131_[i]=$T131; }
                  if (Label == "TMT-10")  {T126_[i]=$T126; T127N_[i]=$T127N; T127C_[i]=$T127C; T128N_[i]=$T128N; T128C_[i]=$T128C; T129N_[i]=$T129N; T129C_[i]=$T129C; T130N_[i]=$T130N; T130C_[i]=$T130C; T131_[i]=$T131;} 
		  if (Label == "TMT-Pro")  {T126_[i]=$T126; T127N_[i]=$T127N; T127C_[i]=$T127C; T128N_[i]=$T128N; T128C_[i]=$T128C; T129N_[i]=$T129N; T129C_[i]=$T129C; T130N_[i]=$T130N; T130C_[i]=$T130C; T131N_[i]=$T131N; T131C_[i]=$T131C; T132N_[i]=$T132N; T132C_[i]=$T132C; T133N_[i]=$T133N; T133C_[i]=$T133C; T134N_[i]=$T134N;}
		 } 

END {C=split(EXP,CN,"\t"); 
     printf "%-s\t", pep[i] >> file_sum; close(file_sum)
     printf "%-s\t", pep[i] >> file_ave; close(file_ave)
  ##   for (c=3; c < C; c=c+1)
	## { 
     for (I=1; I <= i; I=I+1)
       { for (e=3; e < C; e=e+1)
	  { if ( CN[e] == EXPT[I] )
	      {c=e; e=C+1;
              }
           }
	   if (Label == "SILAC-2")
			{ if (Light[I] > 0) { Val_L[c]=Val_L[c] Light[I] ","; N_L[c]=N_L[c]+1;}
                 	  if (Heavy[I] > 0) { Val_H[c]=Val_H[c] Heavy[I] ","; N_H[c]=N_H[c]+1;}
			}
		  if (Label == "SILAC-3")
			{ if (Light[I] > 0)  { Val_L[c]=Val_L[c] Light[I] ","; N_L[c]=N_L[c]+1;}
		 	  if (Heavy[I] > 0)  { Val_H[c]=Val_H[c] Heavy[I] ","; N_H[c]=N_H[c]+1;}
		 	  if (Medium[I] > 0) { Val_M[c]=Val_M[c] Medium[I] ","; N_M[c]=N_M[c]+1;}
			}
		  if (Label == "iTRAQ-4")
			{ if (I114_[I] > 0) { Val_I114[c]=Val_I114[c] I114_[I] ","; N_I114[c]=N_I114[c]+1;}
                          if (I115_[I] > 0) { Val_I115[c]=Val_I115[c] I115_[I] ","; N_I115[c]=N_I115[c]+1;}
                          if (I116_[I] > 0) { Val_I116[c]=Val_I116[c] I116_[I] ","; N_I116[c]=N_I116[c]+1;}
                          if (I117_[I] > 0) { Val_I117[c]=Val_I117[c] I117_[I] ","; N_I117[c]=N_I117[c]+1;}
			}
                  if (Label == "iTRAQ-8")
                        { if (I114_[I] > 0) { Val_I114[c]=Val_I114[c] I114_[I] ","; N_I114[c]=N_I114[c]+1;}
                          if (I115_[I] > 0) { Val_I115[c]=Val_I115[c] I115_[I] ","; N_I115[c]=N_I115[c]+1;}
                          if (I116_[I] > 0) { Val_I116[c]=Val_I116[c] I116_[I] ","; N_I116[c]=N_I116[c]+1;}
                          if (I117_[I] > 0) { Val_I117[c]=Val_I117[c] I117_[I] ","; N_I117[c]=N_I117[c]+1;}
                          if (I118_[I] > 0) { Val_I118[c]=Val_I118[c] I118_[I] ","; N_I118[c]=N_I118[c]+1;}
                          if (I119_[I] > 0) { Val_I119[c]=Val_I119[c] I119_[I] ","; N_I119[c]=N_I119[c]+1;}
                          if (I120_[I] > 0) { Val_I120[c]=Val_I120[c] I120_[I] ","; N_I120[c]=N_I120[c]+1;}
                          if (I121_[I] > 0) { Val_I121[c]=Val_I121[c] I121_[I] ","; N_I121[c]=N_I121[c]+1;}
                        }
                 if (Label == "TMT-6")
			{ if (T126_[I] > 0) { Val_T126[c]=Val_T126[c] T126_[I] ","; N_T126[c]=N_T126[c]+1;}
			  if (T127_[I] > 0) { Val_T127[c]=Val_T127[c] T127_[I] ","; N_T127[c]=N_T127[c]+1;}
                          if (T128_[I] > 0) { Val_T128[c]=Val_T128[c] T128_[I] ","; N_T128[c]=N_T128[c]+1;}
                          if (T129_[I] > 0) { Val_T129[c]=Val_T129[c] T129_[I] ","; N_T129[c]=N_T129[c]+1;}
                          if (T130_[I] > 0) { Val_T130[c]=Val_T130[c] T130_[I] ","; N_T130[c]=N_T130[c]+1;}
                          if (T131_[I] > 0) { Val_T131[c]=Val_T131[c] T131_[I] ","; N_T131[c]=N_T131[c]+1;}
			}
		   if (Label == "TMT-10")
                        { if (T126_[I] > 0)  { Val_T126[c]=Val_T126[c] T126_[I] ","; N_T126[c]=N_T126[c]+1;}
                          if (T127N_[I] > 0) { Val_T127N[c]=Val_T127N[c] T127N_[I] ","; N_T127N[c]=N_T127N[c]+1;}
                          if (T127C_[I] > 0) { Val_T127C[c]=Val_T127C[c] T127C_[I] ","; N_T127C[c]=N_T127C[c]+1;}
                          if (T128N_[I] > 0) { Val_T128N[c]=Val_T128N[c] T128N_[I] ","; N_T128N[c]=N_T128N[c]+1;}
                          if (T128C_[I] > 0) { Val_T128C[c]=Val_T128C[c] T128C_[I] ","; N_T128C[c]=N_T128C[c]+1;}
                          if (T129N_[I] > 0) { Val_T129N[c]=Val_T129N[c] T129N_[I] ","; N_T129N[c]=N_T129N[c]+1;}
                          if (T129C_[I] > 0) { Val_T129C[c]=Val_T129C[c] T129C_[I] ","; N_T129C[c]=N_T129C[c]+1;}
                          if (T130N_[I] > 0) { Val_T130N[c]=Val_T130N[c] T130N_[I] ","; N_T130N[c]=N_T130N[c]+1;}
                          if (T130C_[I] > 0) { Val_T130C[c]=Val_T130C[c] T130C_[I] ","; N_T130C[c]=N_T130C[c]+1;}
			  if (T131_[I] > 0) { Val_T131[c]=Val_T131[c] T131_[I] ","; N_T131[c]=N_T131[c]+1;}
			}
                   if (Label == "TMT-Pro")
                        { if (T126_[I] > 0)  { Val_T126[c]=Val_T126[c] T126_[I] ","; N_T126[c]=N_T126[c]+1;}
                          if (T127N_[I] > 0) { Val_T127N[c]=Val_T127N[c] T127N_[I] ","; N_T127N[c]=N_T127N[c]+1;}
                          if (T127C_[I] > 0) { Val_T127C[c]=Val_T127C[c] T127C_[I] ","; N_T127C[c]=N_T127C[c]+1;}
                          if (T128N_[I] > 0) { Val_T128N[c]=Val_T128N[c] T128N_[I] ","; N_T128N[c]=N_T128N[c]+1;}
                          if (T128C_[I] > 0) { Val_T128C[c]=Val_T128C[c] T128C_[I] ","; N_T128C[c]=N_T128C[c]+1;}
                          if (T129N_[I] > 0) { Val_T129N[c]=Val_T129N[c] T129N_[I] ","; N_T129N[c]=N_T129N[c]+1;}
                          if (T129C_[I] > 0) { Val_T129C[c]=Val_T129C[c] T129C_[I] ","; N_T129C[c]=N_T129C[c]+1;}
                          if (T130N_[I] > 0) { Val_T130N[c]=Val_T130N[c] T130N_[I] ","; N_T130N[c]=N_T130N[c]+1;}
                          if (T130C_[I] > 0) { Val_T130C[c]=Val_T130C[c] T130C_[I] ","; N_T130C[c]=N_T130C[c]+1;}
                          if (T131N_[I] > 0) { Val_T131N[c]=Val_T131N[c] T131N_[I] ","; N_T131N[c]=N_T131N[c]+1;}
                       	  if (T131C_[I] > 0) { Val_T131C[c]=Val_T131C[c] T131C_[I] ","; N_T131C[c]=N_T131C[c]+1;}
                          if (T132N_[I] > 0) { Val_T132N[c]=Val_T132N[c] T132N_[I] ","; N_T132N[c]=N_T132N[c]+1;}
                          if (T132C_[I] > 0) { Val_T132C[c]=Val_T132C[c] T132C_[I] ","; N_T132C[c]=N_T132C[c]+1;} 
                          if (T133N_[I] > 0) { Val_T133N[c]=Val_T133N[c] T133N_[I] ","; N_T133N[c]=N_T133N[c]+1;}
                          if (T133C_[I] > 0) { Val_T133C[c]=Val_T133C[c] T133C_[I] ","; N_T133C[c]=N_T133C[c]+1;}
                          if (T134N_[I] > 0) { Val_T134N[c]=Val_T134N[c] T134N_[I] ","; N_T134N[c]=N_T134N[c]+1;}
                        }

		 pst[c]="PH";
	   }
      for (c=3; c < C; c=c+1)
	{ if (Label == "SILAC-2") 
		{if ( N_L[c] > 0 ) { CV(Val_L[c]); Ave_L[c]=mean; SD_L[c]=sd; CV_L[c]=cv; SUM_L[c]=sum; } else {N_L[c]="0";}
	   	 if ( N_H[c] > 0 ) { CV(Val_H[c]); Ave_H[c]=mean; SD_H[c]=sd; CV_H[c]=cv; SUM_H[c]=sum; } else {N_H[c]="0";}
                 printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t", pst[c] "(L" N_L[c] ", M" N_M[c] ", H" N_H[c] ")", SUM_L[c], Ave_L[c], CV_L[c], SUM_H[c], Ave_H[c], CV_H[c]  >> file_ave; close(file_ave);
		}

	 if (Label == "SILAC-3") 
		{if ( N_L[c] > 0 ) { CV(Val_L[c]); Ave_L[c]=mean; SD_L[c]=sd; CV_L[c]=cv; SUM_L[c]=sum;} 
			else {N_L[c]="0";}
                 if ( N_H[c] > 0 ) { CV(Val_H[c]); Ave_H[c]=mean; SD_H[c]=sd; CV_H[c]=cv; SUM_H[c]=sum;} 
                        else {N_H[c]="0";}
		 if ( N_M[c] > 0 ) { CV(Val_M[c]); Ave_M[c]=mean; SD_M[c]=sd; CV_M[c]=cv; SUM_M[c]=sum;} 
			else {N_M[c]="0";}
		 printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t", pst[c] "(L" N_L[c] ", M" N_M[c] ", H" N_H[c] ")", SUM_L[c], Ave_L[c], CV_L[c], SUM_M[c], Ave_M[c], CV_M[c], SUM_H[c], Ave_H[c], CV_H[c]  >> file_ave; close(file_ave); 
		}

	if (Label == "iTRAQ-4")
		{if (N_I114[c] > 0) {CV(Val_I114[c]); Ave_I114[c]=mean; SD_I114[c]=sd; CV_I114[c]=cv; SUM_I114[c]=sum; } else {N_I114[c]="0"}
                 if (N_I115[c] > 0) {CV(Val_I115[c]); Ave_I115[c]=mean; SD_I115[c]=sd; CV_I115[c]=cv; SUM_I115[c]=sum; } else {N_I115[c]="0"}
                 if (N_I116[c] > 0) {CV(Val_I116[c]); Ave_I116[c]=mean; SD_I116[c]=sd; CV_I116[c]=cv; SUM_I116[c]=sum; } else {N_I116[c]="0"}
                 if (N_I117[c] > 0) {CV(Val_I117[c]); Ave_I117[c]=mean; SD_I117[c]=sd; CV_I117[c]=cv; SUM_I117[c]=sum; } else {N_I117[c]="0"}
		 printf "%-s\t%-s\t%-s\t%-s\t%-s\t", pst[c] "(114_" N_I114[c] ", 115_" N_I115[c] ", 116_" N_I116[c] ", 117_" N_I117[c] ")", SUM_I114[c], Ave_I114[c], CV_I114[c], SUM_I115[c], Ave_I115[c], CV_I115[c], SUM_I116[c], Ave_I116[c], CV_I116[c], SUM_I117[c], Ave_I117[c], CV_I117[c]  >> file_ave; close(file_ave);
                }

        if (Label == "iTRAQ-8")
		{if (N_I114[c] > 0) {CV(Val_I114[c]); Ave_I114[c]=mean; SD_I114[c]=sd; CV_I114[c]=cv; SUM_I114[c]=sum; } else {N_I114[c]="0"}
                 if (N_I115[c] > 0) {CV(Val_I115[c]); Ave_I115[c]=mean; SD_I115[c]=sd; CV_I115[c]=cv; SUM_I115[c]=sum; } else {N_I115[c]="0"}
                 if (N_I116[c] > 0) {CV(Val_I116[c]); Ave_I116[c]=mean; SD_I116[c]=sd; CV_I116[c]=cv; SUM_I116[c]=sum; } else {N_I116[c]="0"}
                 if (N_I117[c] > 0) {CV(Val_I117[c]); Ave_I117[c]=mean; SD_I117[c]=sd; CV_I117[c]=cv; SUM_I117[c]=sum; } else {N_I117[c]="0"}
		 if (N_I118[c] > 0) {CV(Val_I118[c]); Ave_I118[c]=mean; SD_I118[c]=sd; CV_I118[c]=cv; SUM_I118[c]=sum; } else {N_I118[c]="0"}
                 if (N_I119[c] > 0) {CV(Val_I119[c]); Ave_I119[c]=mean; SD_I119[c]=sd; CV_I119[c]=cv; SUM_I119[c]=sum; } else {N_I119[c]="0"}
                 if (N_I120[c] > 0) {CV(Val_I120[c]); Ave_I120[c]=mean; SD_I120[c]=sd; CV_I120[c]=cv; SUM_I120[c]=sum; } else {N_I120[c]="0"}
                 if (N_I121[c] > 0) {CV(Val_I121[c]); Ave_I121[c]=mean; SD_I121[c]=sd; CV_I121[c]=cv; SUM_I121[c]=sum; } else {N_I121[c]="0"}
		 printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t", pst[c] "(114_" N_I114[c] ", 115_" N_I115[c] ", 116_" N_I116[c] ", 117_" N_I117[c] ", 118_" N_I118[c] ", 119_" N_I119[c] ", 120_" N_I120[c] ", 121_" N_I121[c] ")", SUM_I114[c], Ave_I114[c], CV_I114[c], SUM_I115[c], Ave_I115[c], CV_I115[c], SUM_I116[c], Ave_I116[c], CV_I116[c], SUM_I117[c], Ave_I117[c], CV_I117[c], SUM_I118[c], Ave_I118[c], CV_I118[c], SUM_I119[c], Ave_I119[c], CV_I119[c], SUM_I120[c], Ave_I120[c], CV_I120[c], SUM_I121[c], Ave_I121[c], CV_I121[c]  >> file_ave; close(file_ave); 
                }

	if (Label == "TMT-6") 
		{if (N_T126[c] > 0) {CV(Val_T126[c]); Ave_T126[c]=mean; SD_T126[c]=sd; CV_T126[c]=cv; SUM_T126[c]=sum; } else {N_T126[c]="0"}
		 if (N_T127[c] > 0) {CV(Val_T127[c]); Ave_T127[c]=mean; SD_T127[c]=sd; CV_T127[c]=cv; SUM_T127[c]=sum; } else {N_T127[c]="0"}
                 if (N_T128[c] > 0) {CV(Val_T128[c]); Ave_T128[c]=mean; SD_T128[c]=sd; CV_T128[c]=cv; SUM_T128[c]=sum; } else {N_T128[c]="0"}
                 if (N_T129[c] > 0) {CV(Val_T129[c]); Ave_T129[c]=mean; SD_T129[c]=sd; CV_T129[c]=cv; SUM_T129[c]=sum; } else {N_T129[c]="0"}
                 if (N_T130[c] > 0) {CV(Val_T130[c]); Ave_T130[c]=mean; SD_T130[c]=sd; CV_T130[c]=cv; SUM_T130[c]=sum; } else {N_T130[c]="0"}
                 if (N_T131[c] > 0) {CV(Val_T131[c]); Ave_T131[c]=mean; SD_T131[c]=sd; CV_T131[c]=cv; SUM_T131[c]=sum; } else {N_T131[c]="0"}
		 printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t", pst[c] "(126_" N_T126[c] ", 127_" N_T127[c] ", 128_" N_T128[c] ", 129_" N_T129[c] ", 230_" N_T130[c] ", 131_" N_T131[c] ")", SUM_T126[c], Ave_T126[c], CV_T126[c], SUM_T127[c], Ave_T127[c], CV_T127[c], SUM_T128[c], Ave_T128[c], CV_T128[c], SUM_T129[c], Ave_T129[c], CV_T129[c], SUM_T130[c], Ave_T130[c], CV_T130[c], SUM_T131[c], Ave_T131[c], CV_T131[c] >> file_ave; close(file_ave);
		}

        if (Label == "TMT-10")
                {if (N_T126[c] > 0) {CV(Val_T126[c]); Ave_T126[c]=mean; SD_T126[c]=sd; CV_T126[c]=cv; SUM_T126[c]=sum; } else {N_T126[c]="0"}
                 if (N_T127N[c] > 0) {CV(Val_T127N[c]); Ave_T127N[c]=mean; SD_T127N[c]=sd; CV_T127N[c]=cv; SUM_T127N[c]=sum; } else {N_T127N[c]="0"}
		 if (N_T127C[c] > 0) {CV(Val_T127C[c]); Ave_T127C[c]=mean; SD_T127C[c]=sd; CV_T127C[c]=cv; SUM_T127C[c]=sum; } else {N_T127C[c]="0"}
                 if (N_T128N[c] > 0) {CV(Val_T128N[c]); Ave_T128N[c]=mean; SD_T128N[c]=sd; CV_T128N[c]=cv; SUM_T128N[c]=sum; } else {N_T128N[c]="0"}
                 if (N_T128C[c] > 0) {CV(Val_T128C[c]); Ave_T128C[c]=mean; SD_T128C[c]=sd; CV_T128C[c]=cv; SUM_T128C[c]=sum; } else {N_T128C[c]="0"}
                 if (N_T129N[c] > 0) {CV(Val_T129N[c]); Ave_T129N[c]=mean; SD_T129N[c]=sd; CV_T129N[c]=cv; SUM_T129N[c]=sum; } else {N_T129N[c]="0"}
                 if (N_T129C[c] > 0) {CV(Val_T129C[c]); Ave_T129C[c]=mean; SD_T129C[c]=sd; CV_T129C[c]=cv; SUM_T129C[c]=sum; } else {N_T129C[c]="0"}
                 if (N_T130N[c] > 0) {CV(Val_T130N[c]); Ave_T130N[c]=mean; SD_T130N[c]=sd; CV_T130N[c]=cv; SUM_T130N[c]=sum; } else {N_T130N[c]="0"}
                 if (N_T130C[c] > 0) {CV(Val_T130C[c]); Ave_T130C[c]=mean; SD_T130C[c]=sd; CV_T130C[c]=cv; SUM_T130C[c]=sum; } else {N_T130C[c]="0"}
                 if (N_T131[c] > 0) {CV(Val_T131[c]); Ave_T131[c]=mean; SD_T131[c]=sd; CV_T131[c]=cv; SUM_T131[c]=sum; } else {N_T131[c]="0"}
		 printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t", pst[c] "(126_" N_T126[c] ", 127N_" N_T127N[c] ", 127C_" N_T127C[c] ", 128N_" N_T128N[c] ", 128C_" N_T128C[c] ", 129N_" N_T129N[c] ", 129C_" N_T129C[c] ", 130N_" N_T130N[c] ", 130C_" N_T130C[c] ", 131_" N_T131[c] ")", SUM_T126[c], Ave_T126[c], CV_T126[c], SUM_T127N[c], Ave_T127N[c], CV_T127N[c], SUM_T127C[c], Ave_T127C[c], CV_T127C[c], SUM_T128N[c], Ave_T128N[c], CV_T128N[c], SUM_T128C[c], Ave_T128C[c], CV_T128C[c], SUM_T129N[c], Ave_T129N[c], CV_T129N[c], SUM_T129C[c], Ave_T129C[c], CV_T129C[c], SUM_T130N[c], Ave_T130N[c], CV_T130N[c], SUM_T130C[c], Ave_T130C[c], CV_T130C[c], SUM_T131[c], Ave_T131[c], CV_T131[c] >> file_ave; close(file_ave);
                }

        if (Label == "TMT-Pro")
                {if (N_T126[c] > 0) {CV(Val_T126[c]); Ave_T126[c]=mean; SD_T126[c]=sd; CV_T126[c]=cv; SUM_T126[c]=sum; } else {N_T126[c]="0"}
                 if (N_T127N[c] > 0) {CV(Val_T127N[c]); Ave_T127N[c]=mean; SD_T127N[c]=sd; CV_T127N[c]=cv; SUM_T127N[c]=sum; } else {N_T127N[c]="0"}
                 if (N_T127C[c] > 0) {CV(Val_T127C[c]); Ave_T127C[c]=mean; SD_T127C[c]=sd; CV_T127C[c]=cv; SUM_T127C[c]=sum; } else {N_T127C[c]="0"}
                 if (N_T128N[c] > 0) {CV(Val_T128N[c]); Ave_T128N[c]=mean; SD_T128N[c]=sd; CV_T128N[c]=cv; SUM_T128N[c]=sum; } else {N_T128N[c]="0"}
                 if (N_T128C[c] > 0) {CV(Val_T128C[c]); Ave_T128C[c]=mean; SD_T128C[c]=sd; CV_T128C[c]=cv; SUM_T128C[c]=sum; } else {N_T128C[c]="0"}
                 if (N_T129N[c] > 0) {CV(Val_T129N[c]); Ave_T129N[c]=mean; SD_T129N[c]=sd; CV_T129N[c]=cv; SUM_T129N[c]=sum; } else {N_T129N[c]="0"}
                 if (N_T129C[c] > 0) {CV(Val_T129C[c]); Ave_T129C[c]=mean; SD_T129C[c]=sd; CV_T129C[c]=cv; SUM_T129C[c]=sum; } else {N_T129C[c]="0"}
                 if (N_T130N[c] > 0) {CV(Val_T130N[c]); Ave_T130N[c]=mean; SD_T130N[c]=sd; CV_T130N[c]=cv; SUM_T130N[c]=sum; } else {N_T130N[c]="0"}
                 if (N_T130C[c] > 0) {CV(Val_T130C[c]); Ave_T130C[c]=mean; SD_T130C[c]=sd; CV_T130C[c]=cv; SUM_T130C[c]=sum; } else {N_T130C[c]="0"}
                 if (N_T131N[c] > 0) {CV(Val_T131N[c]); Ave_T131N[c]=mean; SD_T131N[c]=sd; CV_T131N[c]=cv; SUM_T131N[c]=sum; } else {N_T131N[c]="0"}
                 if (N_T131C[c] > 0) {CV(Val_T131C[c]); Ave_T131C[c]=mean; SD_T131C[c]=sd; CV_T131C[c]=cv; SUM_T131C[c]=sum; } else {N_T131C[c]="0"}
                 if (N_T132N[c] > 0) {CV(Val_T132N[c]); Ave_T132N[c]=mean; SD_T132N[c]=sd; CV_T132N[c]=cv; SUM_T132N[c]=sum; } else {N_T132N[c]="0"}
                 if (N_T132C[c] > 0) {CV(Val_T132C[c]); Ave_T132C[c]=mean; SD_T132C[c]=sd; CV_T132C[c]=cv; SUM_T132C[c]=sum; } else {N_T132C[c]="0"}
                 if (N_T133N[c] > 0) {CV(Val_T133N[c]); Ave_T133N[c]=mean; SD_T133N[c]=sd; CV_T133N[c]=cv; SUM_T133N[c]=sum; } else {N_T133N[c]="0"}
                 if (N_T133C[c] > 0) {CV(Val_T133C[c]); Ave_T133C[c]=mean; SD_T133C[c]=sd; CV_T133C[c]=cv; SUM_T133C[c]=sum; } else {N_T133C[c]="0"}
                 if (N_T134N[c] > 0) {CV(Val_T134N[c]); Ave_T134N[c]=mean; SD_T134N[c]=sd; CV_T134N[c]=cv; SUM_T134N[c]=sum; } else {N_T134N[c]="0"}
                 printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t", pst[c] "(126_" N_T126[c] ", 127N_" N_T127N[c] ", 127C_" N_T127C[c] ", 128N_" N_T128N[c] ", 128C_" N_T128C[c] ", 129N_" N_T129N[c] ", 129C_" N_T129C[c] ", 130N_" N_T130N[c] ", 130C_" N_T130C[c] ", 131_" N_T131[c] ")", SUM_T126[c], Ave_T126[c], CV_T126[c], SUM_T127N[c], Ave_T127N[c], CV_T127N[c], SUM_T127C[c], Ave_T127C[c], CV_T127C[c], SUM_T128N[c], Ave_T128N[c], CV_T128N[c], SUM_T128C[c], Ave_T128C[c], CV_T128C[c], SUM_T129N[c], Ave_T129N[c], CV_T129N[c], SUM_T129C[c], Ave_T129C[c], CV_T129C[c], SUM_T130N[c], Ave_T130N[c], CV_T130N[c], SUM_T130C[c], Ave_T130C[c], CV_T130C[c], SUM_T131N[c], Ave_T131N[c], CV_T131N[c], SUM_T131C[c], Ave_T131C[c], CV_T131C[c], SUM_T132N[c], Ave_T132N[c], CV_T132N[c], SUM_T132C[c], Ave_T132C[c], CV_T132C[c], SUM_T133N[c], Ave_T133N[c], CV_T133N[c], SUM_T133C[c], Ave_T133C[c], CV_T133C[c], SUM_T134N[c], Ave_T134N[c], CV_T134N[c] >> file_ave; close(file_ave);
                }
	}	
       printf "\n" >> file_sum; close(file_sum);
       printf "\n" >> file_ave; close(file_ave);
     }
