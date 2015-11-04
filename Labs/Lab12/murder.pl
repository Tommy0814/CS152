victim(mr_boddy).
victim(cook).
victim(motorist).
victim(police_officer).
victim(yvette).
victim(singing_telegram).

suspect(professor_plum).
suspect(mrs_peacock).
suspect(mrs_white).
suspect(miss_scarlet).
suspect(colonel_mustard).
suspect(mr_green).
suspect(wadsworth).

weapon(wrench).
weapon(candlestick).
weapon(lead_pipe).
weapon(knife).
weapon(revolver).
weapon(rope).

room(hall).
room(kitchen).
room(lounge).
room(library).
room(billiard_room).

murder(mr_boddy,candlestick,hall).
murder(cook,knife,kitchen).
murder(motorist,wrench,lounge).
murder(police_officer,lead_pipe,library).
murder(singing_telegram,revolver,hall).
murder(yvette,rope,billiard_room).

motive(professor_plum, mr_boddy).
motive(mrs_peacock, mr_boddy).
motive(mrs_white, mr_boddy).
motive(miss_scarlet, mr_boddy).
motive(colonel_mustard, mr_boddy).
motive(mr_green, mr_boddy).

motive(mrs_peacock, cook).
motive(colonel_mustard, motorist).
motive(miss_scarlet, yvette).
motive(colonel_mustard, yvette).
motive(mrs_white, yvette).
motive(miss_scarlet, police_officer).
motive(professor_plum, singing_telegram).
motive(wadsworth, singing_telegram).

false(colonel_mustard, rope).
false(professor_plum, revolver).
false(mrs_peacock, candlestick).
false(miss_scarlet, billiard_room).
false(professor_plum, kitchen).
false(colonel_mustard, mr_boddy).
false(mrs_white, mr_boddy).
false(mr_green, murder).


% Update accuse to solve the murders.
% Add more facts and rules as needed.
accuse(V,S) :- murder(V,W,R), motive(S, V), not(false(V, S)), suspect(S).
