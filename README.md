# PegParser

Using PetitParser to parse PEGs, with a view to automatically generating parsers to parse the grammars they describe


## Installing PegParser
I haven't worked out how to manage Metacello, so you have to manually install Petit Parser first:

```Smalltalk
Metacello new
  baseline: 'PetitParser';
  repository: 'github://moosetechnology/PetitParser';
  onConflictUseIncoming;
  load.

Metacello new
  baseline: 'PegParser';
  repository: 'github://johnhwoods/PegParser';
  onConflictUseIncoming;
  load.```

The comment for `PegHandParser` is a valid PEG - it is the PEG that defines PEGS with some additional PEG (ie #...) comments.  So the raw parse can be obtain by inspecting the result of `PegHandParser new parse: PegHandParser comment`.  Further processing of the AST is performed by the subclass `PegHandEvaluator` although at the moment this is just a few methods that flatten some of the ASTs.

## Next Steps
- I based PegParser on PetitParser but will be rebasing it on PetitParser2, looks reasonably straightforward
- I probably need help creating a proper BaselineOf that managers the dependencies properly
- Needs testing to check parsing is correct
- Extensions to automagically create parsers from PEGs, rather than just parsing them

## Need Help?
[open an issue](https://github.com/johnhwoods/PegParser/issues)