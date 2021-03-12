| parseTree |

Metacello new
    repository: 'github://dtlewis290/OSProcess-Tonel/src';
    baseline: 'OSProcess';
    load.

Metacello new
    repository: 'github://johnhwoods/PegParser/src';
    baseline: 'PegParser';
    load.

parseTree := PegParser new parse: PegParser comment.

OSProcess thisOSProcess stdOut
    nextPutAll: parseTree class name, String cr.

Smalltalk snapshot: false andQuit: true

