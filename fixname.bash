#!/bin/bash
echo $0
#declare -i i="0" file_number
files_renamed="0"

echo Type the file prefix
read prefix
echo Type the file extension
read ext
echo Type the first file of the series
read first
echo Type the last file of the series
read last
i="$first"
len_prefix="${#prefix}"
len_ext="${#ext}"
function get_file_number
{
		
	for file in $(ls $prefix*.$ext)
		do
			declare -i len_num="$[${#file}-$[$len_prefix+$len_ext]-1]"
			#file_number="${file:$len_prefix:4}"
			file_number="$(ls $prefix*.$ext | tr -d [:alpha:][:punct:])" 
			echo $[$file_number+1]
		done	
		#return $len_num #{$len_num,$file_number}
}
#declare -i len_num=len_num="$[${#(ls $prefix*.$ext)}-$[$len_prefix+$len_ext]-1]"
#get_file_number
function fix_gap
{
	gap_start="$i" gap_size="0"
	#echo $gap_size	
	until [ -e ./$prefix$[$gap_start+$gap_size].$ext ]
	do
		
		gap_size="$[$gap_size+1]"
		if [ $gap_size -gt 100 ]; then
			printf "\nEnd of the series (Gap greater than 100 files. Hint:check if the last file exists)\n"
			#printf "\nSeries contains $i files and $files_renamed files have been renamed!\n"
			killall ${0:2}
		fi
	done
	
	next_file="$[$gap_start+$gap_size]"
	#printf "\ngap found: starting at $gap_start and ending at $next_file"
	while [ -e ./$prefix$next_file.$ext ]
		do
			printf "\n$prefix$[$next_file].$ext -> $prefix$[$gap_start].$ext"
			mv ./$prefix$next_file.$ext ./$prefix$gap_start.$ext
			files_renamed=$[$files_renamed+1]
			gap_start=$[$gap_start+1]	
		done
	i="$first";
}

while [ $i -le $last ] # [ -e ./$1$i.$2 ]
		
	do
		if [ -e ./$prefix$i.$ext ]; then
		
			#echo "file $prefix$i.$ext exists!"
			i="$[$i+1]"
		
		else 
			#echo "file $prefix$i.$ext does not exist!"
			fix_gap
					
		fi
		#killall fixname.bash
	done
#printf "Series contains $i files "
printf "\n$files_renamed files renamed!"
