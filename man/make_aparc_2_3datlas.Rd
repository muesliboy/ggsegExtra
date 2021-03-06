% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create-ggseg3d-atlas.R
\name{make_aparc_2_3datlas}
\alias{make_aparc_2_3datlas}
\title{Create cortical ggseg3d-atlas from annot-file}
\usage{
make_aparc_2_3datlas(
  annot = "aparc",
  subject = "fsaverage5",
  hemisphere = c("rh", "lh"),
  surface = c("inflated", "LCBC", "white"),
  subjects_dir = freesurfer::fs_subj_dir(),
  annot_dir = file.path(subjects_dir, subject, "label"),
  output_dir = tempdir(),
  ncores = parallel::detectCores() - 2,
  cleanup = TRUE,
  verbose = TRUE
)
}
\arguments{
\item{annot}{annotation file, with name [hemi].[annot].annot abd be in annot_dir}

\item{subject}{Freesurfer subject, must exist in whatever subject directory
specified or set in the environment with $SUBJECTS_DIR}

\item{hemisphere}{hemisphere, either "rh" or "lh"}

\item{surface}{Freesurfer surface}

\item{subjects_dir}{Freesurfer subject directory}

\item{annot_dir}{path to directory with annot-files}

\item{output_dir}{output directory path}

\item{ncores}{number of cores for parallel processing (default numcores-2)}

\item{cleanup}{logical to toggle removal of all intermediary files}

\item{verbose}{logical indicating to be verbose or not}
}
\value{
nested data frame as ggseg3d-atlas
}
\description{
Function loops through hemispheres and surfaces
to create a data frame that is ready to use with 
ggseg3d.
}
\details{
It is recommended that you change the region names
for the atlas, and the atlas name to something shorter.
See the dk_3d atlas for examples.
}
\examples{
\dontrun{
dt <- aparc_2_3datlas()
dt <- aparc_2_3datlas(annot = "aparc.a2009s")
dt <- aparc_2_3datlas(surface = "sphere")
}
}
