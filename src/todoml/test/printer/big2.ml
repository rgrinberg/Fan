
let f a  c =
  a.{1,2,3} <- c 

let f a b d e f c = begin 
  a.{1,2,3,4,5}<-c;
  a.{1,2,3,4,5};
  b.{1,2,3,4}<-c;
  b.{1,2,3,4};
  d.{1,2,3}<-c;
  d.{1,2,3};
  e.{1,2}<-c;
  e.{1,2};
  f.{1}<-c;
  f.{1}
end

















