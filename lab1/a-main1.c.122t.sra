
;; Function print_fibonacci_sequence (print_fibonacci_sequence, funcdef_no=24, decl_uid=2549, cgraph_uid=25, symbol_order=27)

void print_fibonacci_sequence (int n)
{
  int t;
  int b.1_1;
  int a.2_2;
  int a.3_3;
  int _4;
  int i.6_5;
  int _6;
  int i.7_7;
  int i.7_18;

  <bb 2> [local count: 118111600]:
  b.1_1 = b;
  a.2_2 = a;
  __printf_chk (1, "%d\n%d\n", a.2_2, b.1_1);
  i.7_18 = i;
  if (i.7_18 < n_10(D))
    goto <bb 3>; [89.00%]
  else
    goto <bb 4>; [11.00%]

  <bb 3> [local count: 955630225]:
  t_11 = b;
  a.3_3 = a;
  _4 = a.3_3 + t_11;
  b = _4;
  __printf_chk (1, "%d\n", _4);
  a = t_11;
  i.6_5 = i;
  _6 = i.6_5 + 1;
  i = _6;
  i.7_7 = i;
  if (i.7_7 < n_10(D))
    goto <bb 3>; [89.00%]
  else
    goto <bb 4>; [11.00%]

  <bb 4> [local count: 118111600]:
  return;

}



;; Function main (main, funcdef_no=23, decl_uid=2550, cgraph_uid=24, symbol_order=26) (executed once)

int main ()
{
  int n;
  int n.0_1;

  <bb 2> [local count: 1073741824]:
  i = 1;
  __printf_chk (1, "\xe8\xaf\xb7\xe8\xbe\x93\xe5\x85\xa5\xe6\x96\x90\xe6\xb3\xa2\xe9\x82\xa3\xe5\xa5\x91\xe6\x95\xb0\xe5\x88\x97\xe7\x9a\x84\xe9\xa1\xb9\xe6\x95\xb0\xef\xbc\x9a");
  scanf ("%d", &n);
  n.0_1 = n;
  print_fibonacci_sequence (n.0_1);
  n ={v} {CLOBBER};
  return 0;

}


