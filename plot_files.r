# plot_files.r : plots temperature data given a USCRN HEADERS.txt file and one 
# or more data files.

source("plot_functions.r")

if ( !interactive() ) {
	# Get the command-line arguments.
	args = commandArgs(trailingOnly=TRUE)

	PlotData(args[1],args[-1])
} else {
	PlotData("HEADERS.txt",list.files(path=".",pattern="CRND.*txt"))
}
