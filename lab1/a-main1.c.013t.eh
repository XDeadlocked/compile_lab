
;; Function main (main, funcdef_no=23, decl_uid=2550, cgraph_uid=24, symbol_order=26)

int main ()
{
  int n;
  int D.2561;

  i = 1;
  printf ("\xe8\xaf\xb7\xe8\xbe\x93\xe5\x85\xa5\xe6\x96\x90\xe6\xb3\xa2\xe9\x82\xa3\xe5\xa5\x91\xe6\x95\xb0\xe5\x88\x97\xe7\x9a\x84\xe9\xa1\xb9\xe6\x95\xb0\xef\xbc\x9a");
  scanf ("%d", &n);
  n.0_1 = n;
  print_fibonacci_sequence (n.0_1);
  D.2561 = 0;
  goto <D.2563>;
  <D.2563>:
  n = {CLOBBER};
  goto <D.2562>;
  D.2561 = 0;
  goto <D.2562>;
  <D.2562>:
  return D.2561;
}



;; Function printf (<unset-asm-name>, funcdef_no=15, decl_uid=964, cgraph_uid=16, symbol_order=15)

__attribute__((artificial, gnu_inline, always_inline))
__attribute__((nonnull (1), format (printf, 1, 2)))
int printf (const char * restrict __fmt)
{
  int D.2564;

  D.2564 = __printf_chk (1, __fmt, __builtin_va_arg_pack ());
  goto <D.2565>;
  <D.2565>:
  return D.2564;
}



;; Function print_fibonacci_sequence (print_fibonacci_sequence, funcdef_no=24, decl_uid=2549, cgraph_uid=25, symbol_order=27)

void print_fibonacci_sequence (int n)
{
  int t;

  b.1_1 = b;
  a.2_2 = a;
  printf ("%d\n%d\n", a.2_2, b.1_1);
  goto <D.2558>;
  <D.2559>:
  t = b;
  a.3_3 = a;
  b.4_4 = b;
  _5 = a.3_3 + b.4_4;
  b = _5;
  b.5_6 = b;
  printf ("%d\n", b.5_6);
  a = t;
  i.6_7 = i;
  _8 = i.6_7 + 1;
  i = _8;
  <D.2558>:
  i.7_9 = i;
  if (n > i.7_9) goto <D.2559>; else goto <D.2557>;
  <D.2557>:
  return;
}


