local hasFlagTable = {["ac"] = true,
["ad"] = true,
["ae"] = true,
["af"] = true,
["ag"] = true,
["ai"] = true,
["al"] = true,
["am"] = true,
["an"] = true,
["ao"] = true,
["aq"] = true,
["ar"] = true,
["as"] = true,
["at"] = true,
["au"] = true,
["aw"] = true,
["ax"] = true,
["az"] = true,
["ba"] = true,
["bb"] = true,
["bd"] = true,
["be"] = true,
["bf"] = true,
["bg"] = true,
["bh"] = true,
["bi"] = true,
["bj"] = true,
["bm"] = true,
["bn"] = true,
["bo"] = true,
["br"] = true,
["bs"] = true,
["bt"] = true,
["bv"] = true,
["bw"] = true,
["by"] = true,
["bz"] = true,
["ca"] = true,
["cc"] = true,
["cd"] = true,
["cf"] = true,
["cg"] = true,
["ch"] = true,
["ci"] = true,
["ck"] = true,
["cl"] = true,
["cm"] = true,
["cn"] = true,
["co"] = true,
["cr"] = true,
["cs"] = true,
["cu"] = true,
["cv"] = true,
["cx"] = true,
["cy"] = true,
["cz"] = true,
["de"] = true,
["dj"] = true,
["dk"] = true,
["dm"] = true,
["do"] = true,
["dz"] = true,
["ec"] = true,
["ee"] = true,
["eg"] = true,
["eh"] = true,
["er"] = true,
["es"] = true,
["et"] = true,
["eu"] = true,
["fi"] = true,
["fo"] = true,
["fr"] = true,
["fj"] = true,
["ga"] = true,
["gb"] = true,
["gd"] = true,
["gl"] = true,
["gm"] = true,
["gw"] = true,
["gp"] = true,
["gt"] = true,
["gy"] = true,
["hu"] = true,
["id"] = true,
["ie"] = true,
["il"] = true,
["in"] = true,
["iq"] = true,
["is"] = true,
["it"] = true,
["ja"] = true,
["jm"] = true,
["jp"] = true,
["kw"] = true,
["kp"] = true,
["lt"] = true,
["lu"] = true,
["lv"] = true,
["lk"] = true,
["ly"] = true,
["ma"] = true,
["mc"] = true,
["mg"] = true,
["mh"] = true,
["mt"] = true,
["mu"] = true,
["ng"] = true,
["nl"] = true,
["no"] = true,
["nr"] = true,
["ni"] = true,
["pa"] = true,
["pe"] = true,
["ph"] = true,
["pk"] = true,
["pl"] = true,
["pr"] = true,
["ps"] = true,
["pt"] = true,
["pm"] = true,
["py"] = true,
["qa"] = true,
["re"] = true,
["ro"] = true,
["ru"] = true,
["rw"] = true,
["sd"] = true,
["se"] = true,
["sj"] = true,
["sl"] = true,
["so"] = true,
["sy"] = true,
["td"] = true,
["to"] = true,
["tn"] = true,
["tv"] = true,
["ua"] = true,
["uk"] = true,
["um"] = true,
["us"] = true,
["uy"] = true,
["uz"] = true,
["vn"] = true,
["wf"] = true,
["ws"] = true,
["ye"] = true,
["yt"] = true,
["yu"] = true,
["za"] = true,
["ge"] = true,
["gr"] = true,
["hk"] = true,
["hn"] = true,
["ht"] = true,
["ir"] = true,
["jo"] = true,
["je"] = true,
["kg"] = true,
["kr"] = true,
["kn"] = true,
["kz"] = true,
["lb"] = true,
["md"] = true,
["mv"] = true,
["mz"] = true,
["me"] = true,
["mk"] = true,
["my"] = true,
["mm"] = true,
["mn"] = true,
["mx"] = true,
["np"] = true,
["nc"] = true,
["nz"] = true,
["om"] = true,
["pg"] = true,
["rs"] = true,
["sa"] = true,
["sc"] = true,
["sg"] = true,
["si"] = true,
["sk"] = true,
["sv"] = true,
["th"] = true,
["tk"] = true,
["tr"] = true,
["tw"] = true,
["tt"] = true,
["tj"] = true,
["ve"] = true,
["hr"] = true,
["xk"] = true
}

function hasFlag(alw7sh)
	if hasFlagTable[alw7sh] then return true else return false end;
end