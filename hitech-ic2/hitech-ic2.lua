local ic2 = require('hitech/ic2')

for k, reactor in pairs(ic2.Reactor.list()) do
    print(k, reactor)
end