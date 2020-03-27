#!/bin/bash

# Print usage if no argument is given

if [ -z "$1" ]; then
cat <<EOU
Generate surfaces for the subcortical structures
segmented with FreeSurfer.

Usage:
sub2srf -s <list of subjects> [-l <list of labels>] [-t <atlas image>] [-d]

Options:
-s <list> : Specify a list of subjects between quotes,
            e.g. -s "john bill mary mark" or a text file
            containing one subject per line.
-l <list> : Specify a list of labels between quotes,
            e.g. "10 11 14 52 253", or a text file
            containing one label per line, or ignore
            this option to convert all labels.
-t          Template where info is going to be extracted from.
            Needs to be in <subject>/mri folder
	    Default aseg.mgz. # added in Sept. 2019 by DVP
-d          Debug mode. Leave all temporary files.


Requirements:
FreeSurfer must have been configured and the variables
FREESURFER_HOME and SUBJECTS_DIR must have been correctly set.

_____________________________________
Anderson M. Winkler
Institute of Living / Yale University
Jul/2009
http://brainder.org
EOU
exit
fi

### DVP ###
###########
# To make it work based on Winkler script we, 
# 1) need to have the image at the same space as norm.mgz for a given subject
# 2) the tract image needs to be a integer image which each integer denoting a single tract. 

# List of labels to be converted if no list is specified
LABLIST="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48"    
TEMPLATE=aseg.mgz

# Check and accept arguments
SBJLIST=""
DEBUG=N
while getopts 's:l:t:d' OPTION
do
  case ${OPTION} in
    s) SBJLIST=$( [[ -f ${OPTARG} ]] && cat ${OPTARG} || echo "${OPTARG}" ) ;;
    l) LABLIST=$( [[ -f ${OPTARG} ]] && cat ${OPTARG} || echo "${OPTARG}" ) ;;
    t) TEMPLATE=${OPTARG} ;;
    d) DEBUG=Y ;;
    esac
done

# Prepare a random string to save temporary files
if hash md5 2> /dev/null ; then
  RND0=$(head -n 1 /dev/random | md5)
elif hash md5sum 2> /dev/null ; then
  RND0=$(head -n 1 /dev/random | md5sum)
fi
RNDSTR=${RND0:0:12}

# Define a function for Ctrl+C as soon as the RNDSTR is defined
trap bashtrap INT
bashtrap()
{
  break ; break
  [[ "${s}" != "" ]] && rm -rf ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR} # try to delete temp files
  exit 1
}


# remove sufix from template
y=${TEMPLATE%.*}

# For each subject
for s in ${SBJLIST} ; do

  # Create directories for temp files and results
  mkdir -p ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}
  mkdir -p ${SUBJECTS_DIR}/${s}/ascii

  # For each label
  for lab in ${LABLIST} ; do

    # Label string
    lab0=$(printf %03d ${lab})

    # Pre-tessellate
    echo "==> Pre-tessellating: ${s}, ${lab0}"
    ${FREESURFER_HOME}/bin/mri_pretess \
           ${SUBJECTS_DIR}/${s}/mri/${TEMPLATE} ${lab} \
           ${SUBJECTS_DIR}/${s}/mri/${TEMPLATE} \
           ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}/aseg_${lab0}_filled.mgz

    # Tessellate
    echo "==> Tessellating: ${s}, ${lab0}"
    ${FREESURFER_HOME}/bin/mri_tessellate \
           ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}/aseg_${lab0}_filled.mgz \
           ${lab} ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}/aseg_${lab0}_notsmooth

    # Smooth
    echo "==> Smoothing: ${s}, ${lab0}"
    ${FREESURFER_HOME}/bin/mris_smooth -nw \
           ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}/aseg_${lab0}_notsmooth \
           ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}/aseg_${lab0}

    # Convert to ASCII
    echo "==> Converting to ASCII: ${s}, ${lab0}"
    ${FREESURFER_HOME}/bin/mris_convert \
           ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}/aseg_${lab0} \
           ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}/${y}_${lab0}.asc
           
    mv ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}/${y}_${lab0}.asc \
       ${SUBJECTS_DIR}/${s}/ascii/${y}_${lab0}.srf
  done

  # Get rid of temp files
  if [ "${DEBUG}" == "Y" ] ; then
    echo "==> Temporary files for ${s} saved at:"
    echo "${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}"
  else
    echo "==> Removing temporary files for ${s}"
    rm -rf ${SUBJECTS_DIR}/${s}/tmp/${RNDSTR}
  fi
  echo "==> Done: ${s}"
done
exit 0
