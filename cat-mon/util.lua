
function delayed_execution(sequence_table, delay_ms)
    local index = 1
    local t = tmr.create()
    local function execute_next()
      if index <= #sequence_table then
        print("running index ", index)
        local function_to_call = sequence_table[index]
        index = index + 1
        function_to_call()
      else
        t:stop()
        print("finished")
      end
    end
    t:alarm(delay_ms, tmr.ALARM_AUTO, execute_next)
end
