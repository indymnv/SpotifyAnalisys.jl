using DataFrames
using Tidier
using CSV
using StatsBase
using Statistics
using Plots
using StatsPlots

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

#Pivot table

#Select amount of songs under 3 minutes

#Histogram for tie durationa

s = plot([histogram(df[:, col],label = col, bins = 20 ) for col in ["Energy", "Key", "Loudness","Speechiness", "Acousticness","Instrumentalness","Liveness", "Valence","Tempo", "Duration_ms",]]...)

savefig(s, "./img/hist_var.png")

#Let's make andja
#Totally skew distributions for likes, coments and Views
s = plot([histogram(df[:, col],label = col, bins = 20 ) for col in ["Views", "Likes", "Comments",]]...)

boxplot(skipmissing(df.Likes))

function calculate_upper_fence(elements_array)
	quantile_3 = quantile(elements_array)[3]
	quantile_1 = quantile(elements_array)[1]
	IQR = quantile_3 - quantile_1
	boundary = quantile_3 + 1.5*IQR
	return boundary
end

upper_bound = calculate_upper_fence(collect(skipmissing(df.Likes)))

df.succesful_song =  df.Likes .> upper_bound

#Fill the missings with the value 0
df.Likes = coalesce.(df.Likes, 0)

@. df.succesful_song = ifelse(df.Likes.> upper_bound, 1.0, 0.0)

#scatterplot for comparing with Like

Plots.scatter(df.Speechiness, df.succesful_song, group = df.succesful_song)

size(df)
df_filtered = dropmissing(df, :Likes) #delete just one row
size(df_filtered)

@chain df_filtered begin
	@group_by(succesful_song)
	@summarize(n = nrow())
end

@df dropmissing(df_filtered, :Energy)  density(:Energy, group = (:succesful_song),)

p1 = @df dropmissing(df_filtered, :Energy)  density(:Energy, group = (:succesful_song),)
p2 = @df dropmissing(df_filtered, :Key)  density(:Key, group = (:succesful_song),)
p3 = @df dropmissing(df_filtered, :Loudness)  density(:Loudness, group = (:succesful_song),)
p4 = @df dropmissing(df_filtered, :Speechiness)  density(:Speechiness, group = (:succesful_song),)
p5 = @df dropmissing(df_filtered, :Acousticness)  density(:Acousticness, group = (:succesful_song),)
p6 = @df dropmissing(df_filtered, :Instrumentalness)  density(:Instrumentalness, group = (:succesful_song),)

plot(p1, p2, p3, p4, p5, p6, layout=(3,2), legend=true)


s = plot([Plots.scatter(df_filtered[:, col], df_filtered.succesful_song, label = col, bins = 20 ,) for col in ["Energy", "Key", "Loudness","Speechiness", "Acousticness","Instrumentalness","Liveness", "Valence","Tempo", "Duration_ms",]]...)

@chain df_filtered begin
	@group_by(succesful_song)
	@summarize(n = nrow())
end

columns = ["Energy", "Key", "Loudness","Speechiness", "Acousticness","Instrumentalness","Liveness", "Valence","Tempo", "Duration_ms","succesful_song"]


df_experiment =df[!,columns] 

CSV.write("df_experiment.csv", df_experiment)

