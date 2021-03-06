% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fs-utils.R
\name{mris_annot2label}
\alias{mris_annot2label}
\title{Convert annotation to label}
\usage{
mris_annot2label(
  annot_file,
  subject = "fsaverage5",
  hemisphere = "lh",
  output_dir = freesurfer::fs_subj_dir(),
  verbose = TRUE
)
}
\arguments{
\item{annot_file}{annotation file path}

\item{subject}{Freesurfer subject, must exist in whatever subject directory
specified or set in the environment with $SUBJECTS_DIR}

\item{hemisphere}{hemisphere, either "rh" or "lh"}

\item{output_dir}{output directory path}

\item{verbose}{logical indicating to be verbose or not}
}
\description{
Convert annotation to label
}
