

  echo "Please select the Orgnism for database searching:"
  PS3_OLD=$PS3
  PS3="Please make a selection=> "; export PS3;
  select Database in Mouse Human Zebra_fish None
  do
   case $Database in
   Mouse) LB_1="Mouse";LB_2="musculus";LB_3="mouse"; DB="MM";Uniq="Mm.seq.uniq";break;;
   Human) LB_1="Homo";LB_2="Human";LB_3="sapiens"; DB="HS";Uniq="Hs.seq.uniq";break;;
   Zebra_fish) LB_1="ebra";LB_2="rerio";LB_3="Danio"; DB="est_others";Uniq="Dr.seq.uniq";break;;
   None) break;;
   *) echo "ERROR: Invalid selection, $REPLY.";;
   esac
  done
  PS3=$PS3_OLD;

  echo "Please specify the labeling system:"
  PS3_OLD=$PS3
  PS3="Please make a selection=> "; export PS3;
  select Label in SILAC iTRAQ-4 iTRAQ-8 TMT-6 TMT-10 TMT-Pro None
  do
   case $Label in
   SILAC) Label="SILAC"; break;;
   iTRAQ-4) Label="iTRAQ-4";Iso_IntF="y"; break;;
   iTRAQ-8) Label="iTRAQ-8";Iso_IntF="y"; break;;
   TMT-6)   Label="TMT-6";Iso_IntF="y"; break;;
   TMT-10)  Label="TMT-10";Iso_IntF="y"; break;;
   TMT-Pro)  Label="TMT-Pro";Iso_IntF="y"; break;;
   None) Label="NONE"; break;;
   *) echo "ERROR: Invalid selection, $REPLY.";;
   esac
  done
  PS3=$PS3_OLD;

 printf "\n" ;

 _starttime=$(date +%s)
 
for i
 do
  name=${i%.*}
  Time=`date +%Y-%m-%d:%H:%M:%S | awk '{split($1,t,":"); T=t[2] t[3]; gsub("-","",t[1]); print t[1] "-" T;}'`
  FOLDER=`echo $name $Time | awk '{print $2 "-" $1;}'`
  mkdir $FOLDER
  mv $i $FOLDER
  cd $FOLDER
 
  _Iso_IntF="No";
  if [ "$Iso_IntF" = "y" ]; then
    echo "Would you like to apply filter for Isolation Interference?"
    echo "If Yes, please specified the cutoff value. (Recommend: 30):"
    echo "If No, please input "No": "
    read _Iso_IntF ; 
    if [ "$_Iso_IntF" != "No" ]; then
        echo "### Selecting spectra without Isolation Interference."
        awk -F"\t" -v IsoIFN=$_Iso_IntF -v name=$name ' 
                 BEGIN { file_NoCoElut=name ".NoCoElut"; file_CoElut=name ".CoElut";}
                 /Sequence/ { for (fs=1; fs<=NF; fs=fs+1)
                                {if ($fs ~ "Interference")
                                        {IntF=fs; 
                                        }   
                                }   
                              printf "%-s\n", $0 > file_NoCoElut; close(file_NoCoElut)
                              printf "%-s\n", $0 > file_CoElut; close(file_CoElut) 
                             }   
            !/Sequence/ {if (($IntF < IsoIFN) && (length($0) > 100)) {printf "%-s\n", $0 >> file_NoCoElut; close(file_NoCoElut)}
                         if ($IntF >=  IsoIFN) {printf "%-s\n", $0 >> file_CoElut; close(file_CoElut)}
                        }' $i
     i=$name.NoCoElut;
     CoIso=`wc -l $name.CoElut | awk '{print $1;}'`
     NoCoIso=`wc -l $name.NoCoElut | awk '{print $1;}'`
     echo "### $CoIso PSM with isolation interference, and $NoCoIso PSM with no or low isolation interference."
     echo "### $CoIso PSMs with isolation interference, and $NoCoIso PSMs with no or low isolation interference (cutoff: $_ISO_IntF)." > $name.sumarry
   else 
     echo "No isolation interference filter was performed." >> $name.sumarry
    fi
 printf "\n" ;
  fi


echo "Would you like to reassign the phosphorylation sites based on phophoRS results?"
echo "If yes, please provide the cutoff score (>70 is recommended, or please input No)." 
read _phRS
if [ "$_phRS" != "n" ]; then
   phRS=$_phRS;
fi

 printf "\n" ;

if [ "$phRS" != "No" ]; then 
	echo "> Re-assigning phosphorylation sites (phosphoRS - $phRS):" 

## Reassign phosphosites based on phosphRS result and remove Ambiguous phosphopeptides 
##      if [ "$_Iso_IntF" = "No" ]; then
##         /xinyanwu/MS_databases/programs/GoDaddy/phRS.assign $i > $name.phRS
##        entry=`wc -l $i | awk '{print $1;}'`
##     else
##         /xinyanwu/MS_databases/programs/GoDaddy/phRS.assign $name.NoCoElut > $name.phRS
##        entry=`wc -l $name.NoCoElut | awk '{print $1;}'`
##     fi
    /research/labs/proteomics/pandey/m202766/programs/phRS.assign $i $phRS > $name.phRS
    entry=`wc -l $i | awk '{print $1;}'`

	 grep -v -w "Ambiguous" $name.phRS > $name.phRS_non
	 grep -w "Ambiguous" $name.phRS > $name.phRS_amb
	Non_amb=`wc -l $name.phRS_non | awk '{print $1;}'`
	Amb=`wc -l $name.phRS_amb | awk '{print $1;}'`
 	i="$name.phRS_non"
	echo " $Non_amb unambiguous PSMs and $Amb ambiguous PSMs are in $entry total identified PSMS." 
	echo " $Non_amb unambiguous PSMs and $Amb ambiguous PSMS are in $entry total identified PSMs (phosphoRS cutoff: $phRS)." >> $name.sumarry
	printf "\n";
else
	echo "No phosphoRS filter is performed." >> $name.sumarry
fi

echo "> Processing quant values ($Label)."

## get information of cell names or experiment groups
 awk -F"\t" '/Sequence/ {for (fs=1; fs<=NF; fs=fs+1) 
							{if ($fs ~ "Experiment") 
								{Exp=fs;
								}
							}
						}
				{split($Exp,expt,"."); 
				 if ((expt[1] !~ "Experiment") && (length(expt[1]) > 0))
					{print expt[1];
					}
			}' $i | sort | uniq > _experiment

 awk -F"\t" '/Sequence/ {for (fs=1; fs<=NF; fs=fs+1)
                                                        {if ($fs ~ "Enrichment")
                                                                {Rich=fs;
                                                                }
                                                        }
                                                }
                                {split($Rich,rich,".");
                                 if ((rich[1] !~ "Enrichment") && (length(rich[1]) > 0))
                                        {print rich[1];
                                        }
                        }' $i | sort | uniq > _enrichment


## write table head to temp a file
 head -n1 $i | awk '{ printf "%-s\t%-s\t%-s\n", "Sequence_M", "File_Scan", $0;}' > _$i;


## differentiate 3-states or 2 states silac
 if [ "$Label" = "SILAC" ] ; then
 	Label=`head -n1 $i | awk '{if ( $0 ~ "Medium") {print "SILAC-3";} else {print "SILAC-2";}}'`; 
 fi

 
## change phosphoAA labels and remove other modifications, and concatenate scan number with file name
 awk -F"\t" '/Sequence/ {for (fs=1; fs<=NF; fs=fs+1) 
							{if (($fs == "Sequence")|| ($fs == "Annotated Sequence")) {Seq=fs;}; 
							 if ($fs == "First Scan") {scanNo=fs;} 
							 if ($fs ~ "Spectrum File") {file=fs;}
							 if ($fs == "Modifications") {Modification=fs;}
							 if ($fs == "Sequence_Ori") {phRS="Yes"}
							 if ($fs == "Annotated Sequence") {version="2.0"}
							 if ($fs == "Enrichment") {Rich=fs}
							}
						} 
			{if ($0 !~ "Sequence")
			   {Sequence=$Seq; 
			      if (phRS == "Yes") 
				{if (($Rich == "pY") || ($Rich == "IMAC") || ($Rich == "TiO2"))
                                    {Sequence=$Seq; gsub("s","pS",Sequence); 
                                     gsub("t","pT",Sequence);gsub("y","pY",Sequence);
				     if (Sequence ~ "].") 
                                        {n=split(Sequence,pep,"."); Sequence=pep[2];
                                        } 
				     } 
				  if ($Rich == "AceK") 
				    {gsub("k","aceK",Sequence); 
				     if (Sequence ~ "].")
                                        {n=split(Sequence,pep,"."); Sequence=pep[2];
                                        }
				    } 
				  if ($Rich == "UbK")
                                    {Sequence=$Seq; gsub("k","ggK",Sequence);
                                     if (Sequence ~ "].")
                                        {n=split(Sequence,pep,"."); Sequence=pep[2];
                                        }
                                    }
				} else 
 				{if (version == "2.0") 
					{mPh=0; 
					 if (Sequence ~ "].") 
						{n=split(Sequence,pep,"."); Sequence=toupper(pep[2]);}
						 m=split($Modification,MOD,"; "); 
						 for (i=1; i<=m; i=i+1)
							   { if (MOD[i] ~ "Phospho") 
								{mPh=mPh+1; split(MOD[i],PH,"(");  
								 PhSite[mPh]=substr(PH[1],2);
								} 
						            }	
						  for (m=1; m<=mPh; m=m+1)
							{ Sequence=substr(Sequence,1,(PhSite[m]+m-2)) "p" substr(Sequence,(PhSite[m]+m-1));
							}
					} else { gsub("m","M",Sequence); gsub("c","C",Sequence);
					  gsub("k","K",Sequence); gsub("r","R",Sequence); 
					  gsub("s","pS",Sequence); gsub("t","pT",Sequence); 
					  gsub("y","pY",Sequence); gsub("q","Q",Sequence);
						}
				}
				printf "%-s\t%-s\t%-s\n", Sequence, $file $scanNo, $0;
			}
		}' $i >> _$i

## generate unique peptides list for query
 E=`awk -F"\t" 'NR == 1 { for (fs=1;fs<=NF;fs=fs+1) 
				{if ($fs == "Identifying Node") 
			  	  {Engine=fs; printf "%-s\t", Engine;
			   	  }
			    	}
		     }
	     NR > 1  { if ( $Engine ~ "Mascot" ) {mascot="yes"}
		       if ( $Engine ~ "Sequest" ) {sequest="yes"}
		     }
	     END { if ((mascot == "yes") && (sequest == "yes"))	
			{ printf "%-s\n", "both"} else {printf "%-s\n", "one"}
		 }' _$i`

 Engine=`echo "$E" | awk '{print $2}'`
 EC=`echo "$E" | awk '{print $1}'`
 
 echo $E 
 echo $Engine "###" $EC 

 if [ $Engine = "both" ]; then
	head -n1 _$i > __$i
	awk -F"\t" -v EC="$EC" ' NR > 1 {print $0}' _$i | sort -t $'\t' -i -r -k$EC,$EC | sort -t $'\t' -i -u -k2,2 >> __$i
	cp __$i _$i 
 fi

 awk '$0 !~ "Sequence" {print $1;}' _$i |sort|uniq > _uniqPep


## generate value of cell name or experiment groups for importing into awk programs
 Exp_Name=`awk 'BEGIN {printf "%-s\t%-s\t", "Peptides", "GI";} {printf "%-s\t",$1; } END {printf "\n";}' _experiment` 

##   echo "$Exp_Name" , ">>>>>777777777>>>>>", $Med;

if [ "$Label" != "NONE" ]; then 
## write table titles
 echo "$Exp_Name" | awk -F"\t" -v Label=$Label '
	{ printf "%-s\t", $1; 
	  for (i=3; i<NF; i=i+1) 
		{ if (Label == "SILAC-2") 
			{printf "%-s\t%-s\t%-s\t%-s\t", $i "_PH", $i "_SumL", $i "_SumH", $i "_Ratio"; } 
		  if (Label == "SILAC-3") 
			{printf "%-s\t%-s\t%-s\t%-s\t", $i "_PH", $i "_SumL", $i "_SumM", $i "_SumH";}
		  if (Label == "iTRAQ-4")
			{printf "%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Sum114", $i "_Sum115",$i "_Sum116",$i "_Sum117";}
		  if (Label == "iTRAQ-8") 
			{printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Sum113", $i "_Sum114", $i "_Sum115",$i "_Sum116",$i "_Sum117", $i "_Sum118",$i "_Sum119",$i "_Sum121";}
		  if (Label == "TMT-6")
			{printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Sum126", $i "_Sum127",$i "_Sum128",$i "_Sum129", $i "_Sum130",$i "_Sum131";}
		  if (Label == "TMT-10")
                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Sum126", $i "_Sum127N",$i "_Sum127C",$i "_Sum128N",$i "_Sum128C",$i "_Sum129N",$i "_Sum129C",$i "_Sum130N",$i "_Sum130C",$i "_Sum131";}

		 if (Label == "TMT-Pro")
			{printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t", $i "_PH", $i "_Sum126", $i "_Sum127N", $i "_Sum127C", $i "_Sum128N", $i "_Sum128C", $i "_Sum129N", $i "_Sum129C", $i "_Sum130N", $i "_Sum130C", $i "_Sum131N", $i "_Sum131C", $i "_Sum132N", $i "_Sum132C", $i "_Sum133N", $i "_Sum133C", $i "_Sum134N";} 
	  printf "\n";}}' > $name\_sum.xls

 echo "$Exp_Name" | awk -F"\t" -v Label=$Label '
        { printf "%-s\t", $1; 
          for (i=3; i<NF; i=i+1) 
                { if (Label == "SILAC-2")
                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t", $i "_PH", $i "_SumL", $i "_AveL", $i "_cvL", $i "_SumH", $i "_AveH", $i "_cvH"; } 
                  if (Label == "SILAC-3")
                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t", $i "_PH", $i "_SumL", $i "_AveL", $i "_cvL", $i "_SumM", $i "_AveM", $i "_cvM", $i "_SumH", $i "_AveH", $i "_cvH";}
                  if (Label == "iTRAQ-4")
                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t" $i "_PH", $i "_Sum114", $i "_Ave114", $i "_cv114", $i "_Sum115", $i "_Ave115", $i "_cv115", $i "_Sum116", $i "_Ave116", $i "_cv116", $i "_Sum117", $i "_Ave117", $i "_cv117";} 
                  if (Label == "iTRAQ-8") 
                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Sum113", $i "_Ave113", $i_cv113, $i "_Sum114", $i "_Ave114", $i "_cv114", $i "_Sum115", $i "_Ave115", $i "_cv115", $i "_Sum116", $i "_Ave116", $i "_cv116", $i "_Sum117", $i "_Ave117", $i "_cv117", $i "_Sum118", $i "_Ave118", $i "_cv118", $i "_Sum119", $i "_Ave119", $i "_cv119", $i "_Sum121", $i "_Ave121", $i "_cv121";}
                  if (Label == "TMT-6")
                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Sum126", $i "_Ave126", $i "_cv126", $i "_Sum127", $i "_Ave127", $i "_cv127", $i "_Sum128", $i "_Ave128", $i "_cv128", $i "_Sum129", $i "_Ave129", $i "_cv129", $i "_Sum130", $i "_Ave130", $i "_cv130", $i "_Sum131", $i "_Ave131", $i "_cv131";}
                  if (Label == "TMT-10")
                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Sum126", $i "_Ave126", $i "_cv126",$i "_Sum127N", $i "_Ave127N", $i "_cv127N",$i "_Sum127C", $i "_Ave127C", $i "_cv127C",  $i "_Sum128N", $i "_Ave128N", $i "_cv128N",   $i "_Sum128C", $i "_Ave128C", $i "_cv128C",  $i "_Sum129N", $i "_Ave129N", $i "_cv129N", $i "_Sum129C", $i "_Ave129C", $i "_cv129C", $i "_Sum130N", $i "_Ave130N", $i "_cv130N", $i "_Sum130C", $i "_Ave130C", $i "_cv130C", $i "_Sum131", $i "_Ave131", $i "_cv131";}
                  if (Label == "TMT-Pro")
                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Sum126", $i "_Ave126", $i "_cv126",$i "_Sum127N", $i "_Ave127N", $i "_cv127N",$i "_Sum127C", $i "_Ave127C", $i "_cv127C",  $i "_Sum128N", $i "_Ave128N", $i "_cv128N",   $i "_Sum128C", $i "_Ave128C", $i "_cv128C",  $i "_Sum129N", $i "_Ave129N", $i "_cv129N", $i "_Sum129C", $i "_Ave129C", $i "_cv129C", $i "_Sum130N", $i "_Ave130N", $i "_cv130N", $i "_Sum130C", $i "_Ave130C", $i "_cv130C", $i "_Sum131N", $i "_Ave131N", $i "_cv131N", $i "_Sum131C", $i "_Ave131C", $i "_cv131C", $i "_Sum132N", $i "_Ave132N", $i "_cv132N", $i "_Sum132C", $i "_Ave132C", $i "_cv132C", $i "_Sum133N", $i "_Ave133N", $i "_cv133N", $i "_Sum133C", $i "_Ave133C", $i "_cv133C", $i "_Sum134N", $i "_Ave134N", $i "_cv134N";}
			 } 
          printf "\n";}' > $name\_ave.xls

##  echo "$Exp_Name" | awk -F"\t" -v Label=$Label '
##        { printf "%-s\t%-s\t", $1, $2;
##          for (i=3; i<NF; i=i+1)
##                { if (Label == "SILAC-2")
##                        {printf "%-s\t%-s\t%-s\t%-s\t", $i "_PH", $i "_MaxL", $i "_MaxH", $i "_Ratio"; }
##                  if (Label == "SILAC-3")
##                        {printf "%-s\t%-s\t%-s\t%-s\t", $i "_PH", $i "_MaxL", $i "_MaxM", $i "_MaxH";}
##                  if (Label == "iTRAQ-4")
##                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Max114", $i "_Max115",$i "_Max116",$i "_Max117";}
##                  if (Label == "iTRAQ-8")
##                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Max113", $i "_Max114", $i "_Max115",$i "_Max116",$i "_Max117", $i "_Max118",$i "_Max119",$i "_Max121";}
##                  if (Label == "TMT-6")
##                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Max126", $i "_Max127",$i "_Max128",$i "_Max129", $i "_Max130",$i "_Max131";}
##                  if (Label == "TMT-10")
##                        {printf "%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t%-s\t",$i "_PH", $i "_Max126", $i "_Max127N",$i "_Max127C",$i "_Max128N",$i "_Max128C",$i "_Max129N",$i "_Max129C",$i "_Max130N",$i "_Max130C",$i "_Max131";}
##                }
##          printf "\n";}' > $name\_max.xls
 if [ "$Label" = "SILAC" ] ; then
 Quant=`head -n1 _$i|awk -F"\t" '{for (fs=1; fs<=NF; fs=fs+1) 
					{if (($fs == "QuanResultID") || ($fs ~ "Quan Result ID")) 	
						{quant=fs; 
						}
					} print quant;	
				}'`
 fi
##  echo "QQQQQQQQQQQQQQ>>>>>>>>>", $Quant;

n=0;
STARTTIME=$(date +%s)
No_uniqPep=`wc -l _uniqPep| awk '{print $1;}'`
 
while read Line
 do 
  head -n1 _$i > _pep
  n=$(($n+1));
 if [ "$Label" = "SILAC" ] ; then
  LC_ALL=C fgrep -w $Line _$i | sort -t $'\t' -i -u -k2,2 | sort -t $'\t' -i -u -k $Quant,$Quant >> _pep
 else 
  LC_ALL=C fgrep -w $Line _$i | sort -t $'\t' -i -u -k2,2 >> _pep
 fi

## echo $Line "######"
## tail -n1 _pep
## echo "######"
 ## scan=`grep -w $Line _$i | awk '{print $2}' | sort -u`;

##  grep -w $Line _$i > _pepTemp

 ## for SC in $scan
 ##  do
 ##    grep -w $SC _pepTemp |sort -t $'\t' -r -u -k $Quant,$Quant | head -n1 >> _pep
##  done

  awk -F"\t" -v EXP="$Exp_Name" -v Label=$Label -v file="$name" -f /research/labs/proteomics/pandey/m202766/programs/consldt_sum.awk _pep  		## >> $name\_sum.xls  
##  awk -F"\t" -v EXP="$Exp_Name" -v Label=$Label -f /xinyanwu/MS_databases/programs/GoDaddy/consldt_ave.awk _pep  >> $name\_ave.xls
##  awk -F"\t" -v EXP="$Exp_Name" -v Label=$Label -f /xinyanwu/MS_databases/programs/GoDaddy/consldt_max.awk _pep  >> $name\_max.xls

  percent=`echo $n $No_uniqPep | awk '{printf "%0.3f", $1/$2*100}'`
  CurrentTTIME=$(date +%s)
  time=$(($CurrentTTIME - $STARTTIME))
  Ntime=`echo $time $n $No_uniqPep |awk '{printf "%0.0f", ($3-$2)*($1/$2);}'`
  ((sec=time%60,  m=time/60, min=m%60, hrs=m/60))
  timespnt=$(printf "%02d:%02d:%02d" $hrs $min $sec)
  ((sec=Ntime%60,  m=Ntime/60, min=m%60, hrs=m/60))
  timeneed=$(printf "%02d:%02d:%02d" $hrs $min $sec)  

  echo -ne "  \r$n/$No_uniqPep;     $percent%;    Spent $timespnt and need ~ $timeneed to finish."

 done < _uniqPep

printf "\n\n"

echo "> Assigning phosphorylation sites based on peptide and protein sequences."
echo $DB
 /research/labs/proteomics/pandey/m202766/programs/gi2gensymb2 $name\_ave.xls $DB 

 echo "> Merging peptides and protein information with quantification values."

 /research/labs/proteomics/pandey/m202766/programs/merg $name\_Sites_T.xls

 /research/labs/proteomics/pandey/m202766/programs/Site_quant $name\_Sites_T_ave.xls

fi

if [ "$Label" = "NONE" ]; then
 echo "> Assigning phosphorylation sites based on peptide and protein sequences."
 cp _uniqPep $name\_pep.xls 
 /research/labs/proteomics/pandey/m202766/programs/gi2gensymb2 $name\_pep.xls $DB

 echo "> Merging peptides and protein information."

 /research/labs/proteomics/pandey/m202766/programs/merg $name\_Sites_T.xls

fi

 /research/labs/proteomics/pandey/m202766/programs/Site_quant $name\_Sites_T_ave.xls

##  rm _*
##  cd ..
 
done

_endtime=$(date +%s)
_time=$(($_endtime - $_starttime))
((sec=_time%60,  m=_time/60, min=m%60, hrs=m/60))
_timespnt=$(printf "%02d:%02d:%02d" $hrs $min $sec)
echo -ne "  \\r  Takes $_timespnt to finish all consolidation procedures."

printf "\n\n";

ls

printf "\n\n";
 
