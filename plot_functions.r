# plot_functions.r : functions for plotting temperature data given a USCRN HEADERS.txt file and one 
# or more data files.
library(ggplot2)
library(lubridate)

# Function to convert date from yyyymmdd format to ordinal date.
convert_date=function(date_yyyymmdd)
{
	yday(as.Date(date_yyyymmdd,format="%Y%m%d"))
}

# Function to read header file.
ReadHeaders=function(headerfile)
{
	all_headers=as.matrix(read.table(file=headerfile))
	# The column names for the data files are located on row 2.
	headers=all_headers[2,]
	headers
}

ReadData=function(datafiles,headers)
{
	# Read the data files into a data frame.
	final_dataset = NULL
	for ( datafile in datafiles )
	{
		# Read the data file into a data frame.
		dataset=read.table(datafile)
		# Assign names to the columns.
		names(dataset)=headers

		# Get the location name from the name of the file.
		location=tools::file_path_sans_ext(paste(strsplit(datafile,"_")[[1]][-1],collapse="_"))
		# Add location name to the data set.
		dataset$location=rep(location,dim(dataset)[1])

		# Replace any missing T_DAILY_MAX values with the value NA.
		dataset$T_DAILY_MAX[which(dataset$T_DAILY_MAX==-9999.0)]=NA

		# Add an ordinal date column.
		dataset$ordinal_date=convert_date(as.character(dataset$LST_DATE))

		# Concatenate data for this location to the final
		# dataset
		if ( is.null(final_dataset) )
			final_dataset=dataset
		else
			final_dataset=rbind(final_dataset,dataset)
	}
	final_dataset
}


PlotData=function(headerfile,datafiles)
{
	# Read the header file.
	headers=ReadHeaders(headerfile)

	# Read the data files.
	final_dataset=ReadData(datafiles,headers)

	if ( !interactive() ) {
		# Open a PNG file for the plot.
		png()
	}

	print(ggplot(data=final_dataset,aes(x=ordinal_date,y=T_DAILY_MAX,group=location))+geom_line(aes(color=location)))

	if ( !interactive() ) {
		dev.off()
	}
}
