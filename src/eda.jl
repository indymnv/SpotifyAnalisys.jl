using DataFrames
using Tidier
using AlgebraOfGraphics
using CairoMakie
using CSV
using StatsBase
using Statistics

# read the file into a dataframe
df = DataFrame(CSV.File("./Spotify_Youtube.csv"))

#Totak of columns
names(df)

#Describe the columns
describe(df)

#Number of rows and columns
size(df)

#Number of artista
@chain df begin
	@group_by(Artist)
	@summarise(n=nrow())
end

# Why we have 10 artist for each --> Different songs for each
@chain df begin
	@filter(Artist=="Claudio Abbado")
	@select(Artist, Track)
end

# Number of songs with type albums --> Album 
@chain df begin
	@group_by(Album_type)
	@summarise(n=nrow())
	@mutate(percentage = (n/20_718))
	@select(Album_type, percentage)
end

# Ranking of songs with more likes/views/coments 
@chain dropmissing(df, [:Views, :Likes, :Comments]) begin
	@arrange(desc(Views),)
	@select(Track,Artist, Views, Likes, Comments)
	@slice(1:12)
end


#Ranking of artist with the average longest songs
@chain dropmissing(df, [:Duration_ms]) begin
	@group_by(Artist)
	@summarise(time_avg_min= mean(Duration_ms)/60_000)
	@arrange(desc(time_avg_min))
	@slice(1:10)
#	@mutate(time_avg = mean(Duration_ms))
end

# There are some outliers in specific songs and may affect the ranking, let's use the median

#Ranking of artist with the median longest songs
@chain dropmissing(df, [:Duration_ms]) begin
	@group_by(Artist)
	@summarise(time_avg_min= median(Duration_ms)/60_000)
	@arrange(desc(time_avg_min))
	@slice(1:10)
#	@mutate(time_avg = mean(Duration_ms))
end

#The ranking is completely different because of this distorion in specific songs.

#Ranking with  Artist with the longest title song names
@chain df begin
	@mutate(lenght_title_song = length.(Track))
	@group_by(Artist)
	@summarise(median_length_title = median(lenght_title_song))
	@arrange(desc(median_length_title))
	@select(Artist, median_length_title)
end

# Create An stratification for amount of likes by percentile - and then compare them between 

#Histogram for tie duration
keep = map(!ismissing, df.Energy)
plt = data(df[keep,:]) * mapping(:Energy)*  histogram(bins =50)
fg = draw(plt)
save("hist.png", fg)


