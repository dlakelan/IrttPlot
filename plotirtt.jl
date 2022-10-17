using StatsPlots, DataFrames, DataFramesMeta, JSON


function plotirttfile(file = "./testdata.json")

    dat = JSON.parsefile(file)
    rts = dat["round_trips"]
    rtdata = DataFrame(timestampns=Vector{Union{Int64,Missing}}(),
        sendns = Vector{Union{Int64,Missing}}(),
        receivens = Vector{Union{Int64,Missing}}(), 
        delayns = Vector{Union{Int64,Missing}}())

    for x in rts
        if haskey(x,"delay") && haskey(x["delay"],"send")
            push!(rtdata,(timestampns = x["timestamps"]["client"]["send"]["monotonic"], sendns= x["delay"]["send"], 
            receivens = x["delay"]["receive"], delayns = x["delay"]["rtt"]))
        else
            push!(rtdata,(timestampns = x["timestamps"]["client"]["send"]["monotonic"], sendns=missing,receivens= missing, delayns=missing))
        end
    end

    mindelay = minimum(skipmissing(rtdata.delayns))

    replace!(x -> ismissing(x) ? -mindelay : x, rtdata.delayns)


    p = @df rtdata scatter(:timestampns / 1e9,:delayns ./ 1e6; size =(1500,500),title="Delay Measurements",xlab="Send Time (s)",ylab="Delay (ms)",
        markersize=0.5,markerstrokewidth=0,
        bottom_margin=10Plots.mm, left_margin=10Plots.mm)
    display(p)
    return (rtdata,p)
end

plotirttfile()
