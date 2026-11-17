# Week 6 Notes For Next Year

Notes recorded on 29 October 2026 after teaching the session.

- There is definitely enough core content for the two 50-minute blocks. The optional dynamic-summary exercise was not reached, which is fine. Keep it optional rather than adding more required material.
- The session felt repetitive. Explanations of the same code parts were spread across too many slides. Consolidate the UI/server/input/output explanations around a small number of examples, then revisit those examples when students need them. Each subsequent slide should add a distinct point rather than explain the same connection again.
- Simplify the slide explanations next year. Protect time for students to inspect, modify and test the examples, with brief shared checks rather than several overlapping explanations before each exercise.

## Introduce Reactivity Graphs From The First Shiny Session

Added on 6 November 2026: introduce reactivity graphs in Session 6, alongside
the first working app, rather than waiting until Session 7. Start with the
familiar histogram: group selection and bin width feed the histogram's render
block. Use the graph to predict what updates when a control changes, then test
the prediction in the app and connect the boxes to the corresponding code.

Keep the graph simple and reuse it as the app develops. Students do not need
to create a shared `reactive()` expression to understand dependencies; introduce
that extra node when shared preparation becomes useful in Session 7. Supply
boxes for early labelling and arrow tasks. Use the graphs to consolidate the
UI/server explanation, reducing repeated verbal walkthroughs rather than adding
another lengthy topic.

## Explain Quoted UI Names And Server Connections

A useful student question concerned why the UI uses names in quotation marks, such as `"number"` and `"double"`, while the server uses `input$number` and `output$double`. This convention needs a clearer introduction for students used to ordinary R variables.

- Explain that `"number"` is a text name assigned to a control, not a reference to an existing R variable. Shiny makes the control's current value available through `input$number`.
- Explain that `textOutput("double")` declares a named location in the interface. The server supplies its content through `output$double <- renderText({ ... })`. The matching text name connects the two parts.
- Distinguish the name, the visible label and the changing value. Keep one concrete example visible while tracing all three.
- Make clear that `input` and `output` are objects supplied by Shiny; they are not prefixes to write inside the UI's quoted names.

## Possible Visual Explanation

Consider one annotated visual showing the UI declaring a control and an output location, Shiny starting the app, the server reading the input and calculating the result, and the result appearing in the named output location. Show the initial value and first displayed result before demonstrating an update.

The user experience can be illustrated as a loop: user changes a control, Shiny updates the dependent calculation, the display changes, and the user chooses another action. Keep that interaction loop distinct from the reactive dependency direction of input to calculation to output; do not imply that a reactive dependency cycle is required.

Use the output-location placeholder to explain how the UI can be defined before its displayed content is calculated. Present the quoted names as Shiny's way of connecting the interface and server, rather than as gaps in ordinary R syntax.
