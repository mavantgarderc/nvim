-- tiny Lua: read N from arg, print first N Fibonacci numbers
local n = tonumber(arg and arg[1]) or 10
local a, b = 0, 1
io.write("fib: ")
for i = 1, n do
  io.write(a)
  if i < n then
    io.write(", ")
  end
  a, b = b, a + b
end
io.write("\n")
