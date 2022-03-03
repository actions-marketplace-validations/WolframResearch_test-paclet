#!/usr/bin/env wolframscript
(* ::Package:: *)

(* :!CodeAnalysis::BeginBlock:: *)
(* :!CodeAnalysis::Disable::SuspiciousSessionSymbol:: *)

print[ a___ ] := WriteString[ "stdout", a, "\n" ];

print[ "Loading Wolfram`PacletCICD` from ", FindFile[ "Wolfram`PacletCICD`" ] ];

Needs[ "Wolfram`PacletCICD`" ];

print[ a___ ] := WriteString[ "stdout", a, "\n" ];

getInput[ name_String ] :=
    Module[ { val },
        val = Environment[ "INPUT_" <> name ];
        print[ name, "=", val ];
        val
    ];

print[ "Checking paclet..." ];

target = getInput[ "TARGET" ];
defNB  = getInput[ "DEFINITION_NOTEBOOK" ];
If[ ! FileExistsQ @ ExpandFileName @ defNB,
    print[ "::error::Definition notebook not found: ", defNB ];
    Exit[ 1 ]
];

debug = Interpreter[ "Boolean" ][ getInput[ "DEBUG" ] ];
If[ ! BooleanQ @ debug,
    print[ "::error::Expected a boolean value for input 'debug' instead of ",
           getInput[ "DEBUG" ]
    ];
    Exit[ 1 ]
];

result =
    Block[
        {
            Print = print,
            DefinitionNotebookClient`BeginConsoleGroup,
            DefinitionNotebookClient`EndConsoleGroup
        },
        Wolfram`PacletCICD`TestPaclet[
            File @ defNB,
            "AnnotateTestIDs" -> True,
            "Target"          -> target,
            "Debug"           -> debug,
            "ConsoleType"     -> "GitHub"
        ]
    ];

print @ result;

If[ MatchQ[ result, _Wolfram`PacletCICD`TestPaclet ],
    print[ "::error::Wolfram`PacletCICD`TestPaclet not defined" ];
    Exit[ 1 ]
];

(* :!CodeAnalysis::EndBlock:: *)