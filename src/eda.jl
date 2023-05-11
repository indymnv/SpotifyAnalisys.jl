using DataFrames
using Plots
using CSV
using StatsBase
using StatsPlots
using Statistics

# read the file into a dataframe
 df = DataFrame(CSV.File("./Spotify_Youtube.csv"))

# create a function to perform feature engineering with one hot encoder
 scatter(df.Energy, df.Loudness)

 plot([histogram(df[:, col],label = col, bins = 10 ) for col in ["Danceability", "Energy","Key","Loudness","Speechiness","Acousticness","Instrumentalness","Liveness","Valence","Tempo","Duration_ms","Views","Likes","Comments"]]...)

# crete a pairplot function will receive a dataframe and will create a plot with several scatterplot to cross information
df_num = dropmissing(df[:,["Danceability", "Energy","Key","Loudness","Speechiness","Acousticness","Instrumentalness","Liveness","Valence","Tempo","Duration_ms","Views","Likes","Comments"]])


gr(size = (1200, 1000))
@df df_num corrplot(cols(1:9), grid = true)


@df df_num cornerplot(cols(1:5),)
