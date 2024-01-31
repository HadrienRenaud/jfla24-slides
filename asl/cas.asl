let address = X[n];
let compare_value = X[s];
let new_value = X[t];
let data = Mem[address];
if data == compare_value then
  Mem[address] = new_value;
end
X[s] = data;
