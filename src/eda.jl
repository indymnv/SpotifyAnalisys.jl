using DataFrames
using Plots
using CSV
using StatsBase

# read the file into a dataframe
 df = DataFrame(CSV.File("./Spotify_Youtube.csv"))

# create a function to perform feature engineering with one hot encoder
 scatter(df.Energy, df.Loudness)

 plot([histogram(df[:, col],label = col, bins = 10 ) for col in ["Danceability", "Energy","Key","Loudness","Speechiness","Acousticness","Instrumentalness","Liveness","Valence","Tempo","Duration_ms","Views","Likes","Comments"]]...)

# crete a pairplot function will receive a dataframe and will create a plot with several scatterplot to cross information

function pairplot(df::DataFrame)
		
end



