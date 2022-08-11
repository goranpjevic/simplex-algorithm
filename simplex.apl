#!/usr/bin/env dyalogscript

⎕fr←1287

infinity←¯1+2*31

init_simplex←{
  A b c←⍵
  0>⌊/b:⎕←'negative value in vector b'
  N←⍳n
  B←n+⍳m
  v←0
  A b c N B v
}

pivot←{
  A b c N B v l e←⍵
  nA←(⍴A)⍴0
  nb←(⍴b)⍴0
  nc←(⍴c)⍴0
  (e⌷nb)←(l⊃b)÷l e⌷A
  g←{(e⍵⌷nA)←(l⍵⌷A)÷l e⌷A}¨N~e
  (e l⌷nA)←1÷l e⌷A
  g←{
    (⍵⌷nb)←(⍵⌷b)-(⍵e⌷A)×e⌷nb
    g←⍵∘{(⍺⍵⌷nA)←(⍺⍵⌷A)-(⍺e⌷A)×e⍵⌷nA}¨N~e
    (⍵l⌷nA)←(-⍵e⌷A)×e l⌷nA
    0
  }¨B~l
  nv←v+(e⌷c)×e⌷nb
  g←{(⍵⌷nc)←(⍵⌷c)-(e⌷c)×e⍵⌷nA}¨N~e
  (l⌷nc)←(-e⌷c)×e l⌷nA
  nN←l∪N~e
  nB←e∪B~l
  nA nb nc nN nB nv
}

simplex←{
  A b c←⍵
  A b c N B v←init_simplex A b c
  A b c N B v←{
    A b c N B v←⍵
    0≥⌈/c:A b c N B v
    e←⊃⍸0<c
    d←(⍴B)⍴0
    pos←⍸0<{⍵ e⌷A}¨B
    pos_val←{(⍵⌷b)÷⍵e⌷A}¨B[pos]
    d←(pos_val@pos)d
    neg←⍸0≥{⍵ e⌷A}¨B
    d←(infinity@neg)d
    l←B[⊃⍋d]
    l=infinity:⎕←'infinite program'
    A b c N B v←pivot A b c N B v l e
    ∇A b c N B v
  }A b c N B v
  x←(b[B]@B)0⍴⍨(≢N)+≢B
  z←v
  ⍪x z
}

a←2⎕nq#'getcommandlineargs'
nm A b c←⍎¨¨(⊢⊆⍨(~0=≢¨))⊃⎕nget(2⊃a)1
n m←⊃nm
A←↑A
b c←⊃¨b c
⎕←simplex A b c
