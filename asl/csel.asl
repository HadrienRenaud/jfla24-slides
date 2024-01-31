var result: bits(64);
if ConditionHolds(cond) then
  result = X[n];
else
  result = X[m];
end

X[d] = result;
