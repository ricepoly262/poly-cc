polycore = require('polycore')

local Var = "TheVar"
local TableVar = {Var,12345}
local Table = {"hi",{{"a",2},"asdf"},Var,TableVar}

polycore.printTable(Table)