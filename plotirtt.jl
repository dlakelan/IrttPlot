using StatsPlots, DataFrames, DataFramesMeta, JSON

file = "./testdata.json"

dat = JSON.parsefile(file)
rts = dat["round_trips"]
rtdata = [[x["timestamps"]["client"]["send"]["monotonic"], x["delay"]["send"], 
    x["delay"]["receive"], x["delay"]["rtt"]] for x in rts if haskey(x,"delay") && haskey(x["delay"],"send")]

plot(map(x->x[1]/1e9,rtdata), map(x->x[4]/1e6,rtdata),title="Delays through time",ylab="Delay (ms)",xlab="Send Time (s)", 
    size =(1500,500))

