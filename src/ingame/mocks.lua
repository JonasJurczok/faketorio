

function when(table, func)
    if (table[func] == nil) then
        error(string.format("Function %s does not exist.", func))
    end

    local stub = {

        old_func = table[func],

        response = nil,

        then_return = function(self, ...)
            self.response = ...
        end,

        revert = function(self)
            table[func] = self.old_func
        end
    }

    table[func] = stub

    setmetatable(stub, {
        __call = function(self)
            return self.response
        end
    })

    return table[func]
end