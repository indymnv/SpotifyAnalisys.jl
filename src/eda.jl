using DataFrames
using Plots
using CSV
using StatsBase

# read the file into a dataframe
df = DataFrame(CSV.File("./Spotify_Youtube.csv"))

# create a function to perform feature engineering with one hot encoder
scatter(df.Energy, df.Loudness)

#histogram with different columns
plot([histogram(df[:, col],label = col, bins = 20 ) for col in ["Danceability",
		"Energy",
		"Key",
		"Loudness",
		"Speechiness",
		"Acousticness",
		"Instrumentalness",
		"Liveness",
		"Valence",
		"Tempo",
		"Duration_ms",
		"Views",
		"Likes",
		"Comments",
]]...)

