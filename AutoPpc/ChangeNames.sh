#!/bin/bash
############################################################################
# In case the CFMI staff names the participants improperly, here's 
# a quick script change the names of all the converted imaging files. 
#
# -junaid.salim.merchant 2018.07.31
############################################################################
#
# Define directory within which to change image file names for. Best to start in the converted folder
# after converting from dicoms
Dir=/media/jm3080/Naider/RDOC/converted/DCNL-RDOC-081
#
# Define bad regular expression in file name to be changed. 
Bad=DCNL_RDOC_081
#
# Define good regular expression in file name to be changed to. 
Good=DCNL-RDOC-081

for s in $(find $Dir -type f -name "$Bad*"); do 
	mv $s ${s/$Bad/$Good} 
done