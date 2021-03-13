| parseTree |

Metacello new
    repository: 'github://dtlewis290/OSProcess-Tonel/src';
    baseline: 'OSProcess';
    load.

Metacello new
  baseline: 'PegParser';
  repository: 'github://johnhwoods/PegParser/src';
  load.

parseTree := PegParser new parse: PegParser comment.

(1 to: 10) do: [ :i |
  OSProcess thisOSProcess stdOut
    nextPutAll: String cr
]

OSProcess thisOSProcess stdOut
  nextPutAll: parseTree class name, String cr.

Smalltalk snapshot: false andQuit: true

