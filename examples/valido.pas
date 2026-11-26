program fatorial;
(* le um numero e calcula o fatorial *)
var n, i, fat: integer;
    ok: boolean;
begin
  read(n);
  fat := 1;
  i := 1;
  while i <= n do
  begin
    fat := fat * i;
    i := i + 1
  end;
  if fat > 1000 then ok := true else ok := false;
  write(fat)
end.
