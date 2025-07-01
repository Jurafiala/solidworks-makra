# solidworks-makra

This repository contains simple VBA macros for SolidWorks. The `PSIForm` user
form now exposes several options for configuring text formatting. When running
the `main` macro you can set:

* Text height
* Bold, italic and underline style
* Font name (from a small list)

Run the macros inside SolidWorks and the selected options will be applied to the
current document through `IGetTextFormat`.
