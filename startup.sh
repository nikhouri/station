#!/bin/bash
# From https://how-to.dev/how-to-create-tmux-session-with-a-script

session="station-kdb+tick"
tmux new-session -d -s $session

# Tickerplant
window=0
tmux rename-window -t $session:$window 'tick'
tmux send-keys -t $session:$window 'q tick.q db tick -p 5010' C-m

# HDB
window=1
tmux new-window -t $session:$window -n 'hdb'
tmux send-keys -t $session:$window 'q tick/hdb.q tick/db -p 5012' C-m

# RDB
window=2
tmux new-window -t $session:$window -n 'rdb'
tmux send-keys -t $session:$window 'q tick/r.q localhost:5010 localhost:5012 -p 5011' C-m