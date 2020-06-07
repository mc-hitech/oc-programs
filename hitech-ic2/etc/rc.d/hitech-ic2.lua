local running = false;

function start()
    running = true;
    print('starting hitech-ic2 server...')
end

function stop()
    running = false;
    print('stopping hitech-ic2 server...')
end

function status()
    print ('status of hitech-ic2 is ' .. (running and 'running' or 'not running'))
end