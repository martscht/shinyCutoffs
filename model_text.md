# Model Definition

You can use the text box below to write your model in [lavaan](http://lavaan.ugent.be/) code. If you do not want to generate the entire model from scratch, we provide a simple model builder below to generate the skeleton of your model. You can edit the generated code in any way you see fit. As a reminder, the core commands of lavaan model syntax are:

Command  | Function
-------- | --------
`~~` | Correlation / Covariance
`~` | Regression
`~1` | Intercept / Mean
`=~` | Factor loading


If your want to generate a more complex model with a purely graphical user interface, you can also take a look at [Onyx](http://onyx.brandmaier.de/) and export the lavaan syntax from there.

Remember that, if you do not provide any data to base the generation of cut-off values on, you should provide population values to each of the parameters.
