let fresh =
  let cnt = ref 0 in
  fun ?(prefix= "_fan")  ()  ->
    incr cnt; Printf.sprintf "%s__%03i_" prefix (!cnt)
